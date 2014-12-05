#Makefile template from 21st Century C by Ben Klemens
P=program_name
OBJECTS= # this a space separated list of .o files like main.o trace.o io.o
CFLAGS=-g -Wall -O3 -std=gnu11
LDLIBS= # like -lzmq
CC=cc

# This rule just specify dependencies make knows how to link .o file together
# it will implicitly use the recipe $(CC) $(LDFLAGS) first.o second.o $(LDLIBS)
$(P): $(OBJECTS)

# There is no need to specify rules for simple .c -> .o , make has implicit rules for each .o target
# main.o: main.c
# $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $*.c 
# where $@ expands to the full target filename
#       $* expands to the target file with the suffix cut of (so if the target is main.o) $* expands to main
#       #< the name of the file that caused this target to be triggered (in the above example main.c)
 

# If it's a regular C compilation and the only thing you want to customize is the dependecies then
# main.o: main.c trace.c io.c
# will for example do that no need to specify the recipe for the rule
