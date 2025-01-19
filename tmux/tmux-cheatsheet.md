Session -> Window -> Panes

windows are shown at the bottom of the screen

pane: window split

# commands:

- press prefix (defaul: ctrl + b)
- commandmode: `:`

## Sessions

### creating a Session

- **tmux** command while not attached to antother tmux session
- **thmux** new command while attached to another tmux session
- **thmux new -s my-session**
- **tmux ls** -> list tmux session in terminal
- **s** -> see tmux session
- **w** -> preview windows for each session for each session
- **tmux attach** -> attaches to most recent session
- **tmux attach -t <sessions name>** -> attaches to session

## windows

- **c** -> create new Window
- **<window number>** -> change between windows
- **n** -> next window
- **p** -> previous window
- **&** -> close window

## panes

- **v** -> split vertical
- **h** -> split horizontal
- **x** -> close pane
- **{** -> move pane
- **}** -> move pane

- **q** -> show pane numbers
- **z** -> zoom in/out
- **!** -> turn pane into window

- **arrow keys**-> move between panes
