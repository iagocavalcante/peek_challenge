defmodule PeekChallenge.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :customer_email, :string
      add :original_value, :integer
      add :balance_due, :integer
      timestamps()
    end
  end
end
