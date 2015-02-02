class Guess < ActiveRecord::Base
  validates :guess, :presence => true
  belongs_to :word
  scope(:not_included, ->do where({:included =>false})end)
end