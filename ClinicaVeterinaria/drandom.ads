package drandom is
	function generate_random_number ( n: in Positive) return Integer;
	procedure reset_seed(n: in integer);
end drandom;
