defmodule PeekChallenge.OrdersManager do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias PeekChallenge.Repo

  alias PeekChallenge.GoblinPay
  alias PeekChallenge.OrderManager.Order
  alias PeekChallenge.OrderManager.Payment

  # get_order - It should be possible to fetch a previously created
  # order given an order identifier. Details about any payments applied
  # to the order should also be included as part of the order response.
  def get_order(order_id) do
    Repo.get(Order, order_id)
    |> Repo.preload(:payments)
  end

  # get_orders_for_customer - It should be possible to fetch a list of
  # persisted orders matching a given customer email address.
  def get_orders_for_customer(customer_email) do
    Repo.all(
      from o in Order,
        where: o.customer_email == ^customer_email
    )
  end

  # apply_payment_to_order - It should be possible to apply a payment to
  #an existing order. It should be possible to call this function
  # multiple times to make installment payments on an order; you should
  # be able to create an order for $50, and then make a $10 payment,
  # another $10 payment and then a $30 payment to fully pay down the
  # order balance. This function should also be idempotent; if a client
  # attempts to make the same payment twice, such as due to a network
  # hiccup while making a request on poor connection, we do not want to
  # apply the payment twice.
  def apply_payment_to_order(attrs \\ %{}) do
    Repo.transaction(fn ->
      # Load the order with payments
      order = get_order(attrs[:order_id])

      # Check if a payment with the same amount already exists for the
      # order
      existing_payment = Enum.find(order.payments, &(&1.amount == attrs[:amount]))

      case existing_payment do
        nil ->
          # No existing payment with the same amount, proceed with the
          # update
          {:ok, payment} =
            %Payment{}
            |> Payment.changeset(attrs)
            |> Repo.insert()

          # Update the order's balance
          {:ok, updated_order} =
            order
            |> Order.changeset(%{balance_due: order.balance_due - payment.amount})
            |> Repo.update!()

          {:ok, updated_order}

        _ ->
          # Payment with the same amount already exists, no need to
          # insert a new payment
          {:ok, order}
      end
    end)
  end

  # create_order_and_pay - It should be possible to create a new order
  # and apply a payment to that order that succeeds or fails as one
  # operation. If applying the payment to the order fails, the order
  # should not come back in the response for any of the get_order*
  # function calls. Try incorporating a call similar to the following
  # into your code, pretending that the function call is the result of
  # making a call to a remote server not under your control:
  def create_order_and_pay(attrs \\ %{}) do
    Repo.transaction(fn ->
      order =
        %Order{}
        |> Order.changeset(attrs)
        |> Repo.insert()

      case GoblinPay.capture_payment(attrs) do
        :success ->
          order
          |> Order.changeset(%{balance_due: 0})
          |> Repo.update()

        :failure ->
          Repo.delete(order)
      end
    end)
  end

  def create_order(attrs \\ %{}) do
    %Order{
      balance_due: attrs[:original_value]
    }
    |> Order.changeset(attrs)
    |> Repo.insert()
  end
end
