defmodule Blog.Catalog do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Blog.Catalog.{Category, Post}
  alias Blog.Repo

  schema "catalogs" do
    field :name, :string
    field :description, :string
    has_many :posts, Blog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(catalog, attrs) do
    catalog
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def list_catalogs do
    Repo.all(__MODULE__)
  end

  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.inserted_at], preload: [:category, :user])
  end

  def get_catalog!(id) do
    Repo.get!(__MODULE__, id)
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def create_catalog(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_catalog(catalog, attrs \\ %{}) do
    catalog
    |> changeset(attrs)
    |> Repo.update()
  end

  def update_post(post, attrs \\ %{}) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_catalog(catalog) do
    Repo.delete(catalog)
  end

  def delete_category(category) do
    Repo.delete(category)
  end

  def delete_post(post) do
    Repo.delete(post)
  end

  def list_posts_by_catalog(catalog_id) do
    Repo.all(from p in Post, where: p.catalog_id == ^catalog_id)
  end

  def list_categories do
    Repo.all(Category)
  end
end
