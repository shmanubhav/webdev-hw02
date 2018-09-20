defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def precedence(token) do
    case token do
      {:op, "*"} -> 3
      {:op, "/"} -> 3
      {:op, "+"} -> 2
      {:op, "-"} -> 2
    end
  end

  def tag(sym) do
    case sym do
      "+" -> {:op, sym}
      "-" -> {:op, sym}
      "*" -> {:op, sym}
      "/" -> {:op, sym}
      _ -> {:num, parse_float(sym)}
    end
  end

  def infixToPostfix(ifx, acc, stk) do
    if (length(ifx) != 0) do
      item = hd(ifx)
      case item do
        {:num, _} -> infixToPostfix(tl(ifx),acc++[item],stk)
        {:op, _} -> 
          if (length(stk) == 0) do
            infixToPostfix(tl(ifx),acc,[item]++stk)
          else 
            popped = hd(stk)
            if (precedence(item)<precedence(popped)) do
              infixToPostfix(ifx,acc++[popped],tl(stk))
            else
              infixToPostfix(tl(ifx),acc,[item]++stk)
            end
          end
      end
    else
      acc++stk
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(&tag/1)
    |> infixToPostfix([],[])
    #|> hd
    #|> parse_float
    #|> :math.sqrt()

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
