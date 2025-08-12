defmodule GradingClient.Answers do
  @moduledoc """
  This module is responsible for checking if an answer is correct.
  It uses the `AnswerStore` to fetch the answer and compares if it is correct or not.
  """
  use GenServer

  alias GradingClient.Answer

  @table :answer_store

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    :ets.new(@table, [:set, :named_table])

    filename = opts[:filename]

    {answers, _} = Code.eval_file(filename)

    modules =
      MapSet.new(answers, fn answer ->
        :ets.insert(@table, {{answer.module_id, answer.question_id}, answer})
        answer.module_id
      end)

    {:ok, %{modules: modules}}
  end

  @doc """
  Checks if the given answer is correct.
  """
  @spec check(integer(), integer(), String.t()) :: :correct | {:incorrect, String.t()}
  def check(module_id, question_id, answer) do
    GenServer.call(__MODULE__, {:check, module_id, question_id, answer})
  end

  @doc """
  Returns the list of modules.
  """
  @spec get_modules() :: [atom()]
  def get_modules() do
    GenServer.call(__MODULE__, :get_modules)
  end

  def get_results() do
    GenServer.call(__MODULE__, :get_results)
  end

  @impl true
  def handle_call(:get_modules, _from, state) do
    {:reply, state.modules, state}
  end

  @impl true
  def handle_call(:get_results, _from, state) do
    data = :ets.lookup(:answer_store, :results)

    results = data[:results] || %{}

    all_data = :ets.match(:answer_store, {{:"$1", :"$2"}, :"$3"})

    results =
      all_data
      |> Enum.sort_by(fn [module, task, _] -> {module, task} end)
      |> Enum.map(fn [module, task, _] ->
        base = %{"module" => module, "task" => task}

        case Map.get(results, {module, task}) do
          nil -> Map.put(base, "result", "❓ Not answered")
          :incorrect -> Map.put(base, "result", "❌ Incorrect")
          :correct -> Map.put(base, "result", "✅ Correct")
        end
      end)

    {:reply, results, state}
  end

  @impl true
  def handle_call({:check, module_id, question_id, answer}, _from, state) do
    key = {module_id, question_id}

    result =
      case :ets.lookup(@table, {module_id, question_id}) do
        [] ->
          {:incorrect, "Question not found"}

        [{_id, %Answer{answer: correct_answer, help_text: help_text}}] ->
          if answer == correct_answer do
            update_results(key, :correct)
            :correct
          else
            update_results(key, :incorrect)
            {:incorrect, help_text}
          end
      end

    {:reply, result, state}
  end

  defp update_results(key, result) do
    results =
      case :ets.lookup(@table, :results) do
        [] -> %{}
        [results: results] -> results
      end

    results = Map.put(results, key, result)

    :ets.insert(@table, {:results, results})
  end
end
