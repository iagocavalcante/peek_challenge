defmodule PeekChallenge.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :integer
      add :order_id, references(:orders, on_delete: :delete_all)
      timestamps()
    end
  end
end
