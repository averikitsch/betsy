class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  before_validation :fix_category

  private
  def fix_category
    if self.name
      self.name = self.name.downcase
    end
  end
end
