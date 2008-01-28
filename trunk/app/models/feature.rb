# == Schema Information
# Schema version: 26
#
# Table name: features
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  description :text          
#  created_at  :datetime      
#  updated_at  :datetime      
#  active      :boolean(1)    default(TRUE)
#

class Feature < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :phones, :join_table => "phones_features"

  validates_format_of :picture_type,
                      :with => /\Aimage\/jpeg\Z|\Aimage\/pjpeg\Z|\Aimage\/gif\Z|\Aimage\/png\Z|\Aimage\/x-png\Z/,
                      :message => 'not supported. Only JPEG, GIF, and PNG image formats are allowed.',
                      :if => :validate_picture_type

  def picture=(picture_data_field)
    return if picture_data_field.blank?
    self.picture_name = picture_data_field.original_filename
    self.picture_type = picture_data_field.content_type.chomp
    self.picture_data = picture_data_field.read
  end

  def validate_picture_type
    # Validate the format of the image only if there is one
    return ((self.picture_name != nil) || (self.picture_type != nil) || (self.picture_data != nil))
  end

  def phones_to_features=(phone_ids)
    @local_phone_ids = phone_ids
    if @local_phone_ids.include?("-1")
      @phones = []
    else
      @phones = Phone.find(@local_phone_ids)
    end
    self.phones = @phones
  end


end
