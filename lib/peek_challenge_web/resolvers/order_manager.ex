
defmodule PeekChallengeWeb.Resolvers.OrderManagerResolver do
  alias PeekChallenge.OrdersManager

  def orders_for_customer(_parent, %{customer_email: customer_email}, _resolution) do
    orders = OrdersManager.get_orders_for_customer(customer_email)
    {:ok, orders}
  end

  def order(_parent, %{id: id}, _resolution) do
    order = OrdersManager.get_order(id)
    IO.inspect(order)
    {:ok, order}
  end

  def create_order(_parent, %{customer_email: customer_email, original_value: original_value}, _resolution) do
    case OrdersManager.create_order(%{customer_email: customer_email, original_value: original_value}) do
      {:error, changeset} ->
        {:error, changeset}
      {:ok, order} ->
        {:ok, order}
    end
  end

  def apply_payment_to_order(_parent, %{order_id: order_id, amount: amount}, _resolution) do
    case OrdersManager.apply_payment_to_order(%{order_id: order_id, amount: amount}) do
      {:ok, order_or_payment} ->
        order_or_payment
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
