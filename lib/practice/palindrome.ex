defmodule Practice.Palindrome do
  def palindrome(str) do
    cpy = str
    cpy
    |>String.reverse()
    |>String.equivalent?(str)
  end
end
