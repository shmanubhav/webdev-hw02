defmodule Practice.Factor do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def factor(x, acc, cur, org) do
    cond do
      (rem(round(x), cur) == 0) ->
        factor(x/cur, acc++[cur], cur, org)
      (cur >=(org/2)) ->
        if length(acc) == 0 do
          acc++[round(org)]
        else
          acc
        end
      (cur == 2) ->
        factor(x, acc, cur + 1, org)
      true ->
        factor(x, acc, cur + 2, org)
    end
  end

  def factor(x) do
    x = Practice.Factor.parse_float(x)
    Enum.join(factor(x, [], 2, x), " x ")
  end
end
