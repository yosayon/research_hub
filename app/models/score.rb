class Score < ActiveRecord::Base
 belongs_to :company
 belongs_to :statement
end