defmodule PeekChallenge.OrderManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PeekChallenge.Blog` context.
  """

  alias PeekChallenge.OrderManager.Order
  alias PeekChallenge.OrderManager.Payment

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert!()
  end

  def create_payment_for_order(order, attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:order, order)
    |> Repo.insert!()
  end

  def create_order_with_payments(attrs \\ %{}) do
    order = create_order(attrs)

    Enum.reduce(attrs[:payments], order, fn payment_attrs, order ->
      create_payment_for_order(order, payment_attrs)
    end)
  end
end
