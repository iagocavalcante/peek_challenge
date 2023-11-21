defmodule PeekChallenge.OrderManager.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount, :integer
    belongs_to :order, PeekChallenge.OrderManager.Order
    timestamps()
  end

  def changeset(%__MODULE__{} = payment, attrs) do
    payment
    |> cast(attrs, [:amount, :order_id])
    |> validate_required([:amount, :order_id])
  end
end
