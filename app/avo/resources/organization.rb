class Avo::Resources::Organization < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :subdomain, as: :text
    field :users, as: :has_many
    # field :quizzes, as: :has_many
    # field :questions, as: :has_many
    # field :answers, as: :has_many
    # field :marks, as: :has_many
    # field :submissions, as: :has_many
    # field :videos, as: :has_many
  end
end
