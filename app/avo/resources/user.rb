class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :first_name, as: :text
    field :last_name, as: :text
    field :username, as: :text
    field :email, as: :text
    field :password, as: :password
    field :role, as: :select, enum: ::User.roles
    # field :status, as: :select, enum: ::User.statuses
    # field :failed_attempts, as: :number
    # field :organization_id, as: :number
    field :organization, as: :belongs_to
  end
end
