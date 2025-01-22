class AddTenantToTables < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :organization, foreign_key: true
    add_reference :quizzes, :organization, foreign_key: true
    add_reference :questions, :organization, foreign_key: true
    add_reference :answers, :organization, foreign_key: true
    add_reference :marks, :organization, foreign_key: true
    add_reference :submissions, :organization, foreign_key: true
    add_reference :videos, :organization, foreign_key: true

    # Add indexes for better query performance
    add_index :users, [ :organization_id, :email ]
    add_index :quizzes, [ :organization_id, :title ]

    # add defalut org and set it to the first org
    default_org = Organization.create!(name: 'KOI VIVA Voce', subdomain: 'students.koi.edu.au')
    User.update_all(organization_id: default_org.id)
    Quiz.update_all(organization_id: default_org.id)
    Question.update_all(organization_id: default_org.id)
    Answer.update_all(organization_id: default_org.id)
    Mark.update_all(organization_id: default_org.id)
    Submission.update_all(organization_id: default_org.id)
    Video.update_all(organization_id: default_org.id)
  end
end
