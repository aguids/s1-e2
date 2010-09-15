# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "test_helper")

class AchievementTest < Test::Unit::TestCase
  describe "new achievement" do
    setup do
      @achievement = Achievement.new("Githuber", "owner")
    end
    
    test "has an owner" do
      assert @achievement.owner
    end

    test "has a name" do
      assert @achievement.name
      assert_match /Githuber/, @achievement.to_s
    end
    
    test "starts as a dog" do
      assert_match /Dog/, @achievement.to_s
    end
  end
end

class StaticAchievementTest < Test::Unit::TestCase
  describe "new static achievement" do
    setup do
      @achievement = StaticAchievement.new("Commiter", ["commit"], :size)
    end
    
    test "has an owner" do
      assert @achievement.owner
    end
    
    test "has a target" do
      assert @achievement.target
    end
  end
  
  describe "leveling" do
    setup do
      @achievement = StaticAchievement.new("Commiter", ["commit"], :size)
    end
    
    test "with no changes to the owner update does nothing" do
      assert_match /Novice/, @achievement.to_s
      
      @achievement.update!
      assert_match /Novice/, @achievement.to_s
    end
    
    test "up one level" do
      @achievement.owner << "commit"
      @achievement.update!
      assert_match /Intermediate/, @achievement.to_s
    end
    
    test "up two levels at once" do
      2.times { @achievement.owner << "commit" }
      @achievement.update!
      assert_match /Advanced/, @achievement.to_s
    end
    
    test "cannot level up past the last level" do
      3.times { @achievement.owner << "commit" }
      @achievement.update!
      assert_match /Master/, @achievement.to_s
      
      @achievement.owner << "commit"
      @achievement.update!
      assert_match /Master/, @achievement.to_s
    end
    
    test "down one level" do
      3.times { @achievement.owner << "commit" }
      @achievement.update!
      assert_match /Master/, @achievement.to_s
      
      @achievement.owner.pop
      @achievement.update!
      assert_match /Advanced/, @achievement.to_s
    end

    test "down two levels at once" do
      3.times { @achievement.owner << "commit" }
      @achievement.update!
      assert_match /Master/, @achievement.to_s
      
      2.times { @achievement.owner.pop }
      @achievement.update!
      assert_match /Intermediate/, @achievement.to_s
    end

    test "cannot level down beneath the first level" do
      @achievement = StaticAchievement.new("Commiter", ["commit"],
          :size, [2,3,4,5,6])
      2.times { @achievement.owner << "commit" }
      @achievement.update!
      assert_match /Novice/, @achievement.to_s
      
      3.times { @achievement.owner.pop }
      @achievement.update!
      assert_match /Dog/, @achievement.to_s
    end
  end
end

class DescendingStaticAchievementTest < Test::Unit::TestCase
  
  describe "new descending static achievement" do
    setup do
      @achievement = DescendingStaticAchievement.new("Issues Cleaner",
          [], :size)
    end
    
    test "starts as a master" do
      assert_match /Master/, @achievement.to_s
    end
  end
end