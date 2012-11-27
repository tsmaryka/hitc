class CommunityMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
  	name						 :string, :required
    street_address   :string, :required
    city             :string, :required
    province         :string, :required
    postal_code      :string, :required
    phone            :string, :required
    primary_language enum_string(:english, :french, :spanish), :default => :english, :required => true
    date_of_birth    :date, :required
    timestamps
  end
  
  has_many :study_invitations, :dependent => :destroy
  has_many :studies, :through => :study_invitations
  
  has_many :study_enrollments, :dependent => :destroy
  has_many :studies, :through => :study_enrollments
  
  belongs_to :user, :class_name => "User", :foreign_key => :user_id
  
  after_create do
   self.user = acting_user
   self.save
  end
  
  named_scope :specialscope, {
	:select => "community_members.*, (community_members.date_of_birth - now()) as age"
  } 
  
  def age
  	Time.diff(Time.now, self.date_of_birth).get(:year)
  end
  
  def is_invited_any
  	invite = StudyInvitation.find(:first, :conditions => ["community_member_id = ?", self.id])
  	return invite != nil
  end
  
  def is_invited(study)
  	invite = StudyInvitation.find(:first, :conditions => ["community_member_id = ? AND study_id = ?", self.id, study.id])
  	return invite != nil
  end
  
  def is_enrolled_any
  	enrollment = StudyEnrollment.find(:first, :conditions => ["community_member_id = ?", self.id])
  	return enrollment != nil
  end
  
  def is_enrolled(study)
  	enrollment = StudyEnrollment.find(:first, :conditions => ["community_member_id = ? AND study_id = ?", self.id, study.id])
  	return enrollment != nil
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up? && acting_user.user_type == "community" && !acting_user.community_details_entered?
  end

  def update_permitted?
   	acting_user == self.user || acting_user.is_manager?
  end

  def destroy_permitted?
    acting_user.is_manager?
  end

  def view_permitted?(field)
  	if self.id == nil
  		return true
  	end
    if acting_user == self.user
    	return true
    end
    if acting_user.is_manager? || acting_user.is_researcher?
    	return true
    end
  end

end
