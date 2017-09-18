classdef People < Animal
    
    
    properties

    end
    
    methods
        function this = People(name,age,gender)
            n = []; a = []; g = [];
            if nargin>=1;n = name;end;
            if nargin>=2;a = age;end;
            if nargin>=3;g = gender;end;
            
            this@Animal(n,a,g);
        end
        
        function introduce(this,emo)
            disp(['my name is ', this.name,...
                '. Im ', num2str(this.age),...
                '. Im ', this.gender,...
                '. Im ', emo]);
            
        end
        
    end
    
end