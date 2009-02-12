# == Schema Information
# Schema version: 26
#
# Table name: phones
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  description  :text          
#  outright     :decimal(9, 2) default(0.0), not null
#  created_at   :datetime      
#  updated_at   :datetime      
#  outofstock   :boolean(1)    
#  discontinued :boolean(1)    
#  picture_name :string(255)   
#  picture_type :string(255)   default("image/jpeg")
#  picture_data :binary        
#  buy_price    :decimal(9, 2) 
#  supplier     :text          
#  partnum      :string(255)   
#  corp_price   :decimal(9, 2) 
#
#

class Phone < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :outright
  validates_format_of :picture_type,
                      :with => /\Aimage\/jpeg\Z|\Aimage\/pjpeg\Z|\Aimage\/gif\Z|\Aimage\/png\Z|\Aimage\/x-png\Z/,
                      :message => 'not supported. Only JPEG, GIF, and PNG image formats are allowed.',
                      :if => :validate_picture_type

  has_and_belongs_to_many :accessories, :join_table => "phones_accessories"
  has_and_belongs_to_many :features, :join_table => "phones_features"
  has_and_belongs_to_many :plans, :join_table => "phones_plans"

  def picture=(picture_data_field)
    return if picture_data_field.blank?
    self.picture_name = picture_data_field.original_filename
    self.picture_type = picture_data_field.content_type.chomp
    self.picture_data = picture_data_field.read
  end

  def picture2=(picture_data_field)
    return if picture_data_field.blank?
    self.picture2_name = picture_data_field.original_filename
    self.picture2_type = picture_data_field.content_type.chomp
    self.picture2_data = picture_data_field.read
  end

  def picture3=(picture_data_field)
    return if picture_data_field.blank?
    self.picture3_name = picture_data_field.original_filename
    self.picture3_type = picture_data_field.content_type.chomp
    self.picture3_data = picture_data_field.read
  end

  def validate_picture_type
    # Validate the format of the image only if there is one
    return ((self.picture_name != nil) || (self.picture_type != nil) || (self.picture_data != nil))
  end

  def accessories_to_phones=(accessory_ids)
#    self.accessories = Accessory.find(accessory_ids)
    @local_accessory_ids = accessory_ids
    if @local_accessory_ids.include?("-1")
      @accessories = []
    else
      @accessories = Accessory.find(@local_accessory_ids)
    end
    self.accessories = @accessories
  end

  def features_to_phones=(feature_ids)
#    self.features = Feature.find(feature_ids)
    @local_feature_ids = feature_ids
    if @local_feature_ids.include?("-1")
      @features = []
    else
      @features = Feature.find(@local_feature_ids)
    end
    self.features = @features
  end
end
