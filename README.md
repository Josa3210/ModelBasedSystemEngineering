# Umbral Uplink Syndicate
- [Umbral Uplink Syndicate](#umbral-uplink-syndicate)
  - [Mission](#mission)
    - [Background](#background)
    - [Project significance](#project-significance)
    - [Technical Requirements:](#technical-requirements)
  - [High Level Decisions](#high-level-decisions)
  - [Capella Structure](#capella-structure)
  - [Reflection](#reflection)


## Mission

### Background

The Umbral Uplink Syndicate, an established space engineering company, has been approached by a scientific research team with an ambitious proposal: establishing Earth's first lunar agricultural research station on the far side of the Moon. This pioneering facility aims to study food cultivation techniques for future space colonies, leveraging unique materials found exclusively in lunar soil.

### Project significance

- Government-backed initiative with secured funding
- First dedicated agricultural research facility on the lunar far side
- Critical step towards sustainable space colonization
- Opportunity to study lunar-specific agricultural conditions

### Technical Requirements:

- Safe delivery and landing of a 3-metric-ton research module
- Establishment of reliable, permanent two-way communication infrastructure

## High Level Decisions

The largest high level decision we needed to make is the solution for the permanent communication. Given the unique challenges of maintaining contact with the far side of the Moon, we conducted a thorough analysis of all viable communication architectures.

Communication Infrastructure Analysis:

A. Fundamental Constraints:

- The Moon's tidally locked nature prevents direct Earth-to-far-side communication
- Earth's rotation affects ground station visibility
- Need for uninterrupted data transmission regardless of orbital positions
- Signal degradation considerations over extreme distances

B. Evaluated Solutions:

1. Lunar Surface Relay Network
    - Concept: Establishing a chain of surface-based transceivers from the near side to the far side
    - Advantages:
        - Fixed infrastructure with predictable performance
        - No orbital mechanics to manage
        - Direct line-of-sight between adjacent nodes
    - Disadvantages:
        - Complex deployment across lunar terrain
        - Multiple points of potential failure
        - Significant hardware redundancy required
        - Challenging maintenance scenarios
2. Polar Orbital Relay
    - Concept: Single satellite in lunar polar orbit providing continuous coverage
    - Advantages:
        - Simplified deployment (single launch)
        - Consistent coverage patterns
        - Lower system complexity
    - Disadvantages:
        - Ridiculous Farm receiver antenna requirements (Height > 640m)
        - More complex orbital calculations
3. Lunar Lagrange Point Relay
    - Concept: Communication satellite positioned at a lunar Lagrange point
    - Advantages:
        - Minimal station-keeping requirements
        - Stable positioning relative to Earth-Moon system
        - Wide coverage area
    - Disadvantages:
        - Increased power requirements due to distance
        - More sophisticated antenna systems needed
        - Higher launch energy requirements
        - Secondary Lunar Relay still required
4. Lunar orbit relay
    - Concept: Relay satellite in the same orbit as Mun but placed just outside the sphere of influence
    - Advantages:
        - Minimal station-keeping requirements
        - Wide coverage Area
        - Lower Launch energy requirements
    - Disadvantages:
        - Only sees part of the far side of the Moon

Selected Approach:
After careful evaluation of these options, we determined that a Lunar orbital relay system provides the optimal balance of reliability, complexity, and feasibility. The selected configuration will:

- Utilize an operational altitude outside the Moon's sphere of influence (>3000km)
- Optimize the grazing angle for consistent signal quality
- Leverage proven communication technologies
- Minimize deployment complexity through single-point installation

This architecture allows us to position the agricultural facility in the optimal location on the far side without compromising communication reliability. The lunar orbit ensures consistent coverage while maintaining reasonable power and antenna requirements for both the satellite and surface station.

## Capella Structure

As you will read in the reflection we found some shortcomings of Arcadia / Capella and followed a specific process:

1. Operational analysis
    1. Start with the Capability analysis and for each capability broke it down into activities and finally assigning each activity to its actor using the operational architecture
    2. Order to read: OCB → OAIB → OAB
2. System analysis
    1. Started with transitioning to system missions and capabilities. Then broke down each capability into system function and finally assigned them in the system architecture.
    2. Order to read: MCB → SDFB → SAB
3. Logical analysis
    1. Started by fleshing out each SDFB into it’s logical parts then created an architecture blank per scenario. All Top level functions have the own LDFB
    2. Order to read: LDFB → LAB
4. Physical analysis
    1. In the logical analysis the rocket design system was present but we chose to omit for the physical analysis (We do mention the simulator used). We started by either converting from logical components to physical components or split up certain logical components into their physical parts. 
    2. Order to read: PAB Structure → PAB Communication system → PAB Mun Lander → PAB Farm operation

## Reflection

The design method is quite powerful especially when working with interdisciplinary problems. The operational phase really fleshes out what is required of each person and the need for the system. We find the limited scenario description really limiting our ability to make a full operational analysis and we had to come up with our own scenario where the problem might occur in. 

The system analysis is a powerful tool for defining system boundaries and seeing the subsystems / functions that are required. A logical analysis fleshing out how certain things will be done without explicitly stating what methods will be used for implementation makes a design system very agile. Finally the physical architecture phase really locks in the design and makes it clear what components can be worked upon individually.

But then we also found a lot of problems, some inherent to the design system and some might be the Capella system:

1. Top down dependency
    1. We often found ourselves lacking a part of the analysis one layer up: e.g. Realizing that a certain system function should be added while already tackling the logical analysis.
    2. One might argue that we did not do the higher level analysis sufficiently enough but there are two issues in that statement: 1. You can’t keep diagramming without getting your hands dirty otherwise you will be doing that forever. 2. Some things you only realize later on when delving deeper into the implementation.
    3. Overall we observed that this shortcoming made us overthink a lot because we were scared we might have overlooked some things. Of course we did forget things and we found it less easy to reincorporate this back in the higher levels (might be a Capella shortcoming?) and made us less agile overall. 
2. Defining design methods
    1. We clearly know that part of designing a rocket system is designing the rocket design system itself. Complicated sentence to say: how are we gonna simulate the performance and get launch system requirements. Especially at the Physical architecture we found no room for these sorts of analysis methods.
3. Trade-off analysis
    1. We made some really clear trade-off analyses, especially when considering the relay location but we found no better place to put this then this README file. Probably a Capella function we missed?
    2. Some trade-off analyses are very much system defining or make it so you cannot even start the operational analysis without careful consideration. E.g: Communication relay system, if we found a way to implement the permanent communication issue from earth we would have one less reason to build the rocket. These are all operational capabilities / activities that are tied to a specific end implementation with no place to clearly process this type. 
4. Drawing hard lines when they are vague
    1. This is probably a shortcoming of every design system but sometimes the boundaries are vague while the design system forces you to draw hard lines. This lack of flexibility in definitions make it more difficult to work with although probably not exclusive to the Arcadia design system. 
5. Reuse of Components
    1. A specific use case we had was that we needed to reuse the design system to create a rocket twice to create two different but similar rockets. We have two choices: Abstract the design system away or duplicate it entirely. If we abstracted the design it left us no room for rocket specific adaptions (in the end, the relay satellite and farm flight paths are completely different). But if we copy over the entire design strategy we do a lot of manual labour, and specific aspects that always come back in both implementation lose this context.

Overall we can see what the design system tries to achieve and how it can help teams to design but need to acknowledge that a lot of experience is required with it so an analysis is done at the appropriate depth for the specific level of analysis. Though it had some flaws which make designing less agile and gives a general feeling of being stuck in infinite diagramming.