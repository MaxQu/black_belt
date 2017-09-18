classdef Animal < handle
    
    
    properties
        name
        age
        gender
    end
    
    methods
        function this = Animal(name,age,gender)
            this.name = name;
            this.age = age;
            this.gender = gender;
        end
        
        function bark(this)
        disp(['wofwof']);
        end
        function introduce(this,emo)
            disp(['wofwof']);
            
        end
        
    end
    
end