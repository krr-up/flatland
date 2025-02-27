# Environment
- sparse connection to force conflicts
- 60x60x6x6
- 50x50x5x10
- 24x24x3x20
- creation seed not unique

# Malfunction quirks
- state machine problem when off map malfunction
    - continues to follow up malfunction problem two malfunctions after each other
    - as it might not be doable as another malfunction could take the field
    - this holds for old malfunctions, but also for malfunctions from the same time which occupy the field the agent would want to spawn

# Adaptations
- log stats
- implement DO_NOTHING