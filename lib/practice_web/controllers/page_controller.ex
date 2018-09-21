defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.double(x)
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc(expr)
    #prefix = Practic.Calc.getPrefix(expr)
    #postfix = Practice.Calc.getPostfix(expr)
    render conn, "calc.html", expr: expr, y: y
  end

  def factor(conn, %{"x" => x}) do
    y = Practice.factor(x)
    render conn, "factor.html", x: x, y: y
  end

  def palindrome(conn, %{"str" => str}) do
    y = String.reverse(str)
    result = Practice.palindrome(str)
    render conn, "palindrome.html", str: str, y: y, result: result
  end
end
