class Product < ActiveRecord::Base
  PRODUCT_TYPES = [ "Producto", "Dinero","Producto Outlet" ]
  attr_accessible :description, :image_url, :price, :title,:ptype,:english_title,:english_description
  has_attached_file :image_url, :styles => { :main => "190x170",:mainprincipal => "350x190", :thumb => "100x100",:bidView =>"330x220" },:keep_old_files => true,:preserve_files => true,:bucket=>"bidspain" 
  before_destroy :clear_atachments 
  has_many :bids,:dependent => :delete_all
  has_many :orders,:dependent => :delete_all

  validates  :title,:description,:price,:image_url, presence: true
  validates  :title, uniqueness: true 
  validates  :price ,numericality:  {greater_than_or_equal_to: 0.00}
  validates  :ptype,inclusion: PRODUCT_TYPES
  
  

  def clear_atachments
    self.image_url.clear
  end
  
  def queue_all_for_delete 
    true
  end
  
  def localicedTitle
    if I18n.locale=="es" or self.english_title==nil then 
      return self.title
    else
      return self.english_title
    end
  end
    
   def localicedDescription
    if I18n.locale=="es" or self.english_description==nil then 
      return self.description
    else
      return self.english_description
    end
   end
       
  def upload_file   
    
    if (self.image_url.respond_to? :original_filename)
      
      name=self.title
      directory = 'public/img/products'
      # create the file path
      path = File.join(directory, self.image_url.original_filename)
      # write the file
      File.open(path, "wb") { |f| f.write(self.image_url.read) }
      self.image_url='img/products/'+self.image_url.original_filename
    end
  end
  
  
  
  public
  def self.getTypes
    return  PRODUCT_TYPES
  end

end
