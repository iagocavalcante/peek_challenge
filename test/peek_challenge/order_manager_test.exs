defmodule PeekChallenge.OrderManagerTest do
  use PeekChallenge.DataCase

  alias PeekChallenge.OrderManager.Order
  alias PeekChallenge.OrderManager.Payment
  alias PeekChallenge.OrderManagerFixtures

  describe "order manager" do

    test "create_order/1 creates an order" do
      attrs = %{customer_email: "test@email.com", original_value: 100, balance_due: 100}

      order = OrderManager.create_order(attrs)

      assert order.id
      assert order.customer_email == attrs[:customer_email]
      assert order.original_value == attrs[:original_value]
      assert order.balance_due == attrs[:balance_due]
    end

    test "create_payment/2 creates a payment" do
      order = OrderManagerFixtures.create_order()

      attrs = %{amount: 100}

      payment = OrderManager.create_payment(order, attrs)

      assert payment.id
      assert payment.amount == attrs[:amount]
      assert payment.order_id == order.id
    end

    test "create_payment/2 updates the order balance_due" do
      order = OrderManagerFixtures.create_order(%{original_value: 100, balance_due: 100})

      attrs = %{amount: 50}

      payment = OrderManager.create_payment(order, attrs)

      assert payment.id
      assert payment.amount == attrs[:amount]
      assert payment.order_id == order.id

      assert order.balance_due == 50
    end

    test "create_payment/2 raises an error if the payment amount is greater than the order balance_due" do
      order = OrderManagerFixtures.create_order(%{original_value: 100, balance_due: 100})

      attrs = %{amount: 150}

      assert_raise Ecto.ConstraintError, fn ->
        OrderManager.create_payment(order, attrs)
      end
    end

    test "get_order/1 returns an order" do
      order = OrderManagerFixtures.create_order()

      assert OrderManager.get_order(order.id) == order
    end

    test "get_order/1 raises an error if the order does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        OrderManager.get_order(0)
      end
    end

    test "get_order/1 returns an order with payments" do
      order = OrderManagerFixtures.create_order_with_payments(%{
        payments: [%{amount: 100}, %{amount: 50}]
      })

      assert OrderManager.get_order(order.id) == order
    end

    test "get_order/1 returns an order with payments sorted by amount" do
      order = OrderManagerFixtures.create_order_with_payments(%{
        payments: [%{amount: 100}, %{amount: 50}]
      })

      assert OrderManager.get_order(order.id) == order
    end
  end
end
