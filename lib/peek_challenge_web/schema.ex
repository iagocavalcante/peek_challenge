defmodule PeekChallengeWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  alias PeekChallengeWeb.Resolvers

  object :create_order do
    field :order, :order
  end

  object :create_payment do
    field :payment, :payment
  end

  object :order do
    field :id, :id
    field :customer_email, :string
    field :original_value, :integer
    field :balance_due, :integer
    field :payments, list_of(:payment)
  end

  object :payment do
    field :id, :id
    field :amount, :integer
    field :order_id, :id
  end

  query do
    field :order, :order do
      arg :id, non_null(:id)
      resolve &Resolvers.OrderManagerResolver.order/3
    end

    field :orders_for_customer, list_of(:order) do
      arg :customer_email, non_null(:string)
      resolve &Resolvers.OrderManagerResolver.orders_for_customer/3
    end
  end

  mutation do
    field :create_order, :create_order do
      arg :customer_email, non_null(:string)
      arg :original_value, non_null(:integer)

      resolve &Resolvers.OrderManagerResolver.create_order/3
    end

    field :apply_payment_to_order, :create_payment do
      arg :order_id, non_null(:id)
      arg :amount, non_null(:integer)

      resolve &Resolvers.OrderManagerResolver.apply_payment_to_order/3
    end
  end
end
