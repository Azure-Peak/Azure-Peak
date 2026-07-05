
//////////////////////
//datum/path_minheap object
//////////////////////

/datum/path_minheap
	var/list/datum/PathNode/L

/datum/path_minheap/New(compare)
	L = new()

//Insert and place at its position a new node in the heap
/datum/path_minheap/proc/Insert(atom/A)

	L.Add(A)
	Swim(length(L))

//removes and returns the first element of the heap
//(i.e the max or the min dependant on the comparison function)
/datum/path_minheap/proc/Pop()
	if(!length(L))
		return 0
	. = L[1]

	L[1] = L[length(L)]
	L.Cut(length(L))
	if(length(L))
		Sink(1)

//Get a node up to its right position in the heap
/datum/path_minheap/proc/Swim(index)
	var/parent = round(index * 0.5)
	while(parent > 0 && ((L[parent].f - L[index].f) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

//Get a node down to its right position in the heap
/datum/path_minheap/proc/Sink(index)
	. = index * 2
	var/heap_len = length(L)
	if(. > heap_len)
		. = 0
	else if(. + 1 > heap_len) { ;; } // . = index * 2, no-op
	else if((L[. + 1].f - L[.].f) < 0)
		. += 1

	while(. > 0 && (L[.].f - L[index].f) < 0)
		L.Swap(index,.) // preserves length so no need to recalculate heap_len
		index = .
		. = index * 2
		if(. > heap_len)
			. = 0
		else if(. + 1 > heap_len) { ;; } // . = index * 2, no-op
		else if((L[. + 1].f - L[.].f) < 0)
			. += 1

//Replaces a given node so it verify the heap condition
/datum/path_minheap/proc/ReSort(atom/A)
	var/index = L.Find(A)
	if(!index)
		return

	Swim(index)
	Sink(index)

/datum/path_minheap/proc/List()
	. = L.Copy()

