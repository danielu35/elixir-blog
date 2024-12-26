defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :active, :boolean, default: false
    field :title, :string
    field :summery, :string
    field :user_id, :id
    field :category_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :summery, :active])
    |> validate_required([:title, :summery, :active])
  end
end
