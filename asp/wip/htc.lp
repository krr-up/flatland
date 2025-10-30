% Track Type 1 - Straight
transition(32800, (s,s)).	% forward
transition(32800, (n,n)).	% forward
transition(1025 , (e,e)).	% forward
transition(1025 , (w,w)).	% forward

% Track Type 8 - Curve
transition(4608 , (n,w)).	% forward	
transition(4608 , (e,s)).	% forward
transition(16386, (w,s)).	% forward	
transition(16386, (n,e)).	% forward
transition(72   , (s,e)).	% forward	
transition(72   , (w,n)).	% forward
transition(2064 , (e,n)).	% forward	
transition(2064 , (s,w)).	% forward

% Track Type 2 - Simple switch (left)
transition(37408, (n,w)).	% left
transition(37408, (e,s)).	% forward
transition(37408, (n,n)).	% forward	
transition(37408, (s,s)).	% forward
transition(17411, (w,s)).	% left
transition(17411, (n,e)).	% forward	
transition(17411, (w,w)).	% forward	
transition(17411, (e,e)).	% forward
transition(32872, (s,e)).	% left
transition(32872, (w,n)).	% forward	
transition(32872, (s,s)).	% forward	
transition(32872, (n,n)).	% forward
transition(3089 , (e,n)).	% left
transition(3089 , (s,w)).	% forward	
transition(3089 , (e,e)).	% forward	
transition(3089 , (w,w)).	% forward

% Track Type 9 - Simple switch (right)
transition(49186, (n,e)).	% right
transition(49186, (w,s)).	% forward	
transition(49186, (n,n)).	% forward	
transition(49186, (s,s)).	% forward
transition(1097 , (w,n)).	% right
transition(1097 , (s,e)).	% forward	
transition(1097 , (w,w)).	% forward	
transition(1097 , (e,e)).	% forward
transition(34864, (s,w)).	% right
transition(34864, (e,n)).	% forward	
transition(34864, (s,s)).	% forward	
transition(34864, (n,n)).	% forward
transition(5633 , (e,s)).	% right
transition(5633 , (n,w)).	% forward	
transition(5633 , (e,e)).	% forward	
transition(5633 , (w,w)).	% forward

% Track Type 3 - Diamond crossing
transition(33825, (s,s)).	% forward	
transition(33825, (n,n)).	% forward	
transition(33825, (w,w)).	% forward	
transition(33825, (e,e)).	% forward

% Track Type 4 - Single-slip switch
transition(38433, (s,s)).	% forward 
transition(38433, (w,w)).	% forward		
transition(38433, (n,n)).	% forward 
transition(38433, (n,w)).	% left
transition(38433, (e,e)).	% forward 
transition(38433, (e,s)).   % right

transition(50211, (e,e)).	% forward 
transition(50211, (s,s)).	% forward		
transition(50211, (w,w)).	% forward 
transition(50211, (w,s)).	% left
transition(50211, (n,n)).	% forward 
transition(50211, (n,e)).   % right

transition(33897, (n,n)).	% forward 
transition(33897, (e,e)).	% forward		
transition(33897, (s,s)).	% forward 
transition(33897, (s,e)).	% left
transition(33897, (w,w)).	% forward 
transition(33897, (w,n)).   % right

transition(35889, (w,w)).	% forward 
transition(35889, (n,n)).	% forward		
transition(35889, (e,e)).	% forward 
transition(35889, (e,n)).	% left
transition(35889, (s,s)).	% forward 
transition(35889, (s,w)).   % right

% Track Type 5 - Double-slip switch
transition(38505, (s,s)).	% forward 
transition(38505, (s,e)).   % left
transition(38505, (n,n)).	% forward 
transition(38505, (n,w)).   % left
transition(38505, (w,w)).	% forward 
transition(38505, (w,n)).   % right
transition(38505, (e,e)).	% forward 
transition(38505, (e,s)).	% right	

transition(52275, (n,n)).	% forward 
transition(52275, (n,e)).   % right
transition(52275, (s,s)).	% forward 
transition(52275, (s,w)).   % right
transition(52275, (e,e)).	% forward 
transition(52275, (e,n)).   % left
transition(52275, (w,w)).	% forward 
transition(52275, (w,s)).	% left

% Track Type 6 - Symmetrical switch
transition(20994, (n,w)).	% left
transition(20994, (e,s)).	% forward
transition(20994, (w,s)).	% forward	
transition(20994, (n,e)).   % right
transition(16458, (w,s)).	% left
transition(16458, (n,e)).	% forward	
transition(16458, (s,e)).	% forward	
transition(16458, (w,n)).   % right
transition(2136 , (s,e)).	% left
transition(2136 , (w,n)).	% forward	
transition(2136 , (e,n)).	% forward	
transition(2136 , (s,w)).   % right
transition(6672 , (e,n)).   % left	
transition(6672 , (s,w)).	% forward	
transition(6672 , (n,w)).	% forward	
transition(6672 , (e,s)).   % right