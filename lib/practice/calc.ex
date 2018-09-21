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

  def evalPrefix(pre, stk) do
    if pre == [] do
      stk
    else
      head = hd(pre)
      case head do
        {:num, numb} -> evalPrefix(tl(pre), [numb]++stk)
        {:op, sym} ->
          el1 = hd(stk)
          el2 = hd(tl(stk))
          case sym do
            "+" -> evalPrefix(tl(pre), [el1+el2]++(tl(tl(stk))))
            "-" -> evalPrefix(tl(pre), [el1-el2]++(tl(tl(stk))))
            "*" -> evalPrefix(tl(pre), [el1*el2]++(tl(tl(stk))))
            "/" -> evalPrefix(tl(pre), [el1/el2]++(tl(tl(stk))))
          end
      end
    end
  end

  def postfixToPrefix(post, stk) do
    if post == [] do
      List.flatten(stk)
    else
      head = hd(post)
      case head do
        {:num, _} -> postfixToPrefix(tl(post), [[head]]++stk);
        {:op, _} ->
          el1 = hd(stk)
          el2 = hd(tl(stk))
          postfixToPrefix(tl(post), [[head,el2,el1]]++tl(tl(stk)))
        _ -> stk 
      end
    end
  end

  def eval(y,acc) do
    {_, y} = y
    acc<>y
  end

  def getPostfix(expr) do
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(&tag/1)
    |> infixToPostfix([],[])
    |> IO.inspect()
    #|> Enum.reduce(&eval/2)
  end
      
  def getPrefix(expr) do
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(&tag/1)
    |> infixToPostfix([],[])
    |> postfixToPrefix([])
    |> IO.inspect()
  end     

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(&tag/1)
    |> infixToPostfix([],[])
    |> postfixToPrefix([])
    |> Enum.reverse()
    |> evalPrefix([])
    |> hd
    |> round()
    #|> :erlang.float_to_binary([decimals: 2])

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
