defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
  :monday | :tuesday | :wednesday
  | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekday_to_index %{
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6,
    :sunday => 7
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    cond do
      schedule == :first -> {year, month, _get_month_day(year, month, 1..7, @weekday_to_index[weekday])}
      schedule == :second -> {year, month, _get_month_day(year, month, 8..14, @weekday_to_index[weekday])}
      schedule == :third -> {year, month, _get_month_day(year, month, 15..21, @weekday_to_index[weekday])}
      schedule == :fourth -> {year, month, _get_month_day(year, month, 22..28, @weekday_to_index[weekday])}
      schedule == :teenth -> {year, month, _get_month_day(year, month, 13..19, @weekday_to_index[weekday])}
      schedule == :last -> {year, month, _get_month_day(year, month, _get_last_week_range(year, month), @weekday_to_index[weekday])}
      true -> {:error, "Unknown schedule"}
    end
  end

  defp _get_month_day(year, month, days_to_consider, weekday) do
    days_to_consider |> Enum.find(fn(day_to_consider) -> Calendar.ISO.day_of_week(year, month, day_to_consider) == weekday end)
  end

  defp _get_last_week_range(year, month), do: _seven_day_range(Calendar.ISO.days_in_month(year, month))

  defp _seven_day_range(days_in_month), do: (days_in_month - 6)..days_in_month

end
