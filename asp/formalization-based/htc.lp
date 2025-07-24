% Track Type 1 - Straight
transition(32800, (s,s)).	
transition(32800, (n,n)).
transition(1025 , (e,e)).	
transition(1025 , (w,w)).

% Track Type 8 - Curve
transition(4608 , (n,w)).	
transition(4608 , (e,s)).
transition(16386, (w,s)).	
transition(16386, (n,e)).
transition(72   , (s,e)).	
transition(72   , (w,n)).
transition(2064 , (e,n)).	
transition(2064 , (s,w)).

% Track Type 2 - Simple switch (left)
transition(37408, (n,w)).	
transition(37408, (e,s)).	
transition(37408, (n,n)).	
transition(37408, (s,s)).
transition(17411, (w,s)).	
transition(17411, (n,e)).	
transition(17411, (w,w)).	
transition(17411, (e,e)).
transition(32872, (s,e)).	
transition(32872, (w,n)).	
transition(32872, (s,s)).	
transition(32872, (n,n)).
transition(3089 , (e,n)).	
transition(3089 , (s,w)).	
transition(3089 , (e,e)).	
transition(3089 , (w,w)).

% Track Type 9 - Simple switch (right)
transition(49186, (n,e)).	
transition(49186, (w,s)).	
transition(49186, (n,n)).	
transition(49186, (s,s)).
transition(1097 , (w,n)).	
transition(1097 , (s,e)).	
transition(1097 , (w,w)).	
transition(1097 , (e,e)).
transition(34864, (s,w)).	
transition(34864, (e,n)).	
transition(34864, (s,s)).	
transition(34864, (n,n)).
transition(5633 , (e,s)).	
transition(5633 , (n,w)).	
transition(5633 , (e,e)).	
transition(5633 , (w,w)).

% Track Type 3 - Diamond crossing
transition(33825, (s,s)).	
transition(33825, (n,n)).	
transition(33825, (w,w)).	
transition(33825, (e,e)).

% Track Type 4 - Single-slip switch
transition(38433, (s,s)). 
transition(38433, (w,w)).		
transition(38433, (n,n)). 
transition(38433, (n,w)).	
transition(38433, (e,e)). 
transition(38433, (e,s)).

transition(50211, (e,e)). 
transition(50211, (s,s)).		
transition(50211, (w,w)). 
transition(50211, (w,s)).	
transition(50211, (n,n)). 
transition(50211, (n,e)).

transition(33897, (n,n)). 
transition(33897, (e,e)).		
transition(33897, (s,s)). 
transition(33897, (s,e)).	
transition(33897, (w,w)). 
transition(33897, (w,n)).

transition(35889, (w,w)). 
transition(35889, (n,n)).		
transition(35889, (e,e)). 
transition(35889, (e,n)).	
transition(35889, (s,s)). 
transition(35889, (s,w)).

% Track Type 5 - Double-slip switch
transition(38505, (s,s)). 
transition(38505, (s,e)).
transition(38505, (n,n)). 
transition(38505, (n,w)).
transition(38505, (w,w)). 
transition(38505, (w,n)).
transition(38505, (e,e)). 
transition(38505, (e,s)).		

transition(52275, (n,n)). 
transition(52275, (n,e)).
transition(52275, (s,s)). 
transition(52275, (s,w)).
transition(52275, (e,e)). 
transition(52275, (e,s)).
transition(52275, (w,w)). 
transition(52275, (w,n)).	

% Track Type 6 - Symmetrical switch
transition(20994, (n,w)).	
transition(20994, (e,s)).	
transition(20994, (w,s)).	
transition(20994, (n,e)).
transition(16458, (w,s)).	
transition(16458, (n,e)).	
transition(16458, (s,e)).	
transition(16458, (w,n)).
transition(2136 , (s,e)).	
transition(2136 , (w,n)).	
transition(2136 , (e,n)).	
transition(2136 , (s,w)).
transition(6672 , (e,n)).	
transition(6672 , (s,w)).	
transition(6672 , (n,w)).	
transition(6672 , (e,s)).