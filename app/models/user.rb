class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: {maximum: 50}
    validates :email, presence: true, length: {maximum: 255},
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationships, source: :user
    
    def follow(other_user)
        unless self == other_user
         self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end    
    
    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end    
    
    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
    end   
    
    has_many :user_microposts
    has_many :likelists, through: :user_microposts, source: :micropost
    
    def like(micropost)
        unless self == micropost.user
          self.user_microposts.find_or_create_by(micropost_id: micropost.id)
        end
    end
    
    def unlike(micropost)
        user_micropost = self.user_microposts.find_by(micropost_id: micropost.id)
        user_micropost.destroy if user_micropost
    end
    
    def like?(micropost)
        self.likelists.include?(micropost)
    end    
    
end
