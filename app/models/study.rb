class Study < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    body :html
    timestamps
  end
 	
 	has_many :study_invitations, :accessible => true, :dependent => :destroy
 	has_many :community_members, :through => :study_invitations
 
 	has_many :study_enrollments, :dependent => :destroy
 	has_many :community_members, :through => :study_enrollments
 	
 	has_many :study_ownerships, :accessible => true, :dependent => :destroy
 	has_many :researchers, :through => :study_ownerships
 	
	has_many :consent_texts, :dependent => :destroy

	after_create do
		if acting_user.signed_up? && acting_user.user_type == "researcher"
			puts "test"
			ownership = StudyOwnership.new()
			ownership.researcher = Researcher.find(:first, :conditions=> ["user_id = ?", acting_user.id])
			ownership.study = self
			ownership.save
		end
	end
	
	#def is_owner(user)?
	#	researcher = Researcher.find(:first, :conditions("user_id = ?", user)
	#	StudyOwnership.find(:first, :conditions => ["researcher_id = ?", researcher.id, "]
	
	
  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? || (acting_user.signed_up? && (acting_user.user_type == "manager" || acting_user.user_type == "researcher"))
  end

  def update_permitted?
    if acting_user.administrator? || (acting_user.signed_up? && acting_user.user_type == "manager")
    	return true
    end
    
    #StudyOwnership.find(:first, :conditions=> ["study_id = ?", self])
    	
  end

  def destroy_permitted?
     acting_user.administrator? || (acting_user.signed_up? && acting_user.user_type == "manager")
  end

  def view_permitted?(field)
    acting_user.signed_up?
  end

end
