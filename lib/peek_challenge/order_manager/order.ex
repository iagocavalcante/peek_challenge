defmodule PeekChallenge.OrderManager.Order do
  use Ecto.Schema

  import Ecto.Changeset

  schema "orders" do
    field :customer_email, :string
    field :original_value, :integer
    field :balance_due, :integer
    has_many :payments, PeekChallenge.OrderManager.Payment
    timestamps()
  end

  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:customer_email, :original_value, :balance_due])
    |> validate_required([:customer_email, :original_value, :balance_due])
  end
end
