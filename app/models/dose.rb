class Dose < ApplicationRecord
  validates :description, presence: true
  validates :cocktail, presence: true, uniqueness: { scope: :ingredient }
  validates :ingredient, presence: true

  belongs_to :cocktail
  belongs_to :ingredient
end
