# 🌟 DarkTibia Global 8.60 - Enhanced Edition

<div align="center">

![Tibia](https://img.shields.io/badge/Tibia-8.60-blue?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJMMTMuMDkgOC4yNkwyMCA5TDEzLjA5IDE1Ljc0TDEyIDIyTDEwLjkxIDE1Ljc0TDQgOUwxMC45MSA4LjI2TDEyIDJaIiBmaWxsPSJjdXJyZW50Q29sb3IiLz4KPC9zdmc+)
![TFS](https://img.shields.io/badge/TFS-1.2-green?style=for-the-badge)
![Client](https://img.shields.io/badge/Client-8.0--8.6-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Enhanced-gold?style=for-the-badge)

**🎮 Premium Tibia 8.60 Server with Modern Enhancements**

*Authentic Old-School Experience with Cutting-Edge Features*

</div>

---

## 📋 Overview

DarkTibia Global 8.60 Enhanced Edition is a meticulously crafted Tibia server that combines the nostalgic feel of classic Tibia 8.0-8.6 with modern TFS 1.2 stability and enhanced gameplay features. Experience the golden age of Tibia with contemporary improvements.

### 🎯 Core Philosophy
- **Authenticity First**: Preserve the classic Tibia 8.60 experience
- **Modern Stability**: Built on TFS 1.2 for reliability and performance  
- **Enhanced Gameplay**: Carefully selected improvements that enhance without disrupting
- **Community Focus**: Features designed to improve player interaction and server management

---

## ✨ Enhanced Features (New!)

### 🎪 **Event Systems**
- **🧟 Zombie Event System** - Dynamic multi-wave survival events with progressive difficulty
  - 10 escalating waves (Rats → Ferumbras)
  - Automatic player registration and rewards
  - Configurable spawn areas and wave timings
  - GM administration commands

### 🏆 **Ranking & Competition**
- **🥇 Advanced Highscore System** - In-game rankings for multiple categories
  - Level, Experience, Magic Level rankings
  - Skill-based leaderboards (All combat skills + fishing)
  - Frags ranking system
  - Auto-excludes GM characters for fair competition

### 👨‍💼 **GM Enhancement Suite**
- **👻 Ghost Mode Plus** - Enhanced invisibility with fake disconnect messages
- **📢 Login Broadcast System** - Configurable welcome messages with visual effects
- **🐎 Mount Management** - Easy mount commands with 20+ available mounts
- **⚡ Anti-Spam Configuration** - Reduced spell text spam for cleaner gameplay

### 🎨 **Visual & QoL Improvements**
- **🔇 Smart Spell Display** - Configurable spell text visibility
- **🎆 Enhanced Effects** - Improved visual feedback for events and actions
- **📱 Modal Window Support** - Modern UI compatibility
- **🎭 Custom Emote System** - Enhanced player expression

---

## 🗺️ World Features

### 🏝️ **Complete World**
- **All Classic Islands**: Rookgaard, Main Continent, Port Hope, Liberty Bay, Svargrond
- **Authentic Quests**: 90%+ of original 8.0 quests fully functional
- **Balanced Economy**: Classic rates with modern stability

### ⚔️ **Combat System**
- **Authentic Damage**: Original 8.0/7.6 spell damages with balance tweaks
- **Classic PvP**: Traditional skull system with modern improvements
- **Raid System**: Dynamic creature raids on towns and cities

### 🏪 **Enhanced NPCs**
- **Fixed TFS 1.2 Compatibility**: All major NPCs updated for modern TFS
- **Bank System**: Fully functional with modern security
- **Spell Teachers**: Complete spell learning system for all vocations
- **Casino & Games**: Entertainment NPCs in major cities

---

## 🔧 Technical Specifications

### 💻 **Server Stack**
- **Engine**: The Forgotten Server (TFS) 1.2
- **Client Support**: 8.0-8.6 (with sprite support up to 12/14)
- **Database**: MySQL/MariaDB optimized
- **Platform**: Windows/Linux compatible

### ⚙️ **Configuration**
- **Rates**: Balanced experience (250x EXP, 30x Skills, 30x Loot, 8x Magic)
- **Protection**: Level 1 protection, 15 kills to red skull
- **Features**: Premium benefits, classic equipment slots, balanced stamina

### 🛡️ **Security & Stability**
- **Modern Architecture**: TFS 1.2 stability with classic gameplay
- **Memory Management**: Optimized for high player counts
- **Anti-Cheat**: Built-in protection systems
- **Backup Systems**: Automatic database optimization

---

## 🚀 Quick Start

### 📋 **Requirements**
- MySQL/MariaDB Server
- TFS 1.2 compiled binary
- Classic Tibia 8.0-8.6 client

### ⚡ **Installation**
1. **Clone Repository**:
   ```bash
   git clone https://github.com/Javiieer/Darktibia860.git
   ```

2. **Database Setup**:
   ```sql
   CREATE DATABASE global;
   SOURCE Schema.sql;
   ```

3. **Configuration**:
   - Edit `config.lua` with your database credentials
   - Configure `data/lib/zombie_event.lua` coordinates for events
   - Adjust rates and features as needed

4. **Launch**:
   ```bash
   ./tfs
   ```

---

## 🎮 Gameplay Features

### 🏰 **Classic Content (100% Complete)**
- ✅ All original 8.0 quests and missions
- ✅ Complete addon system through quests
- ✅ All classic raids and events
- ✅ Balanced monster spawns and loot
- ✅ Original rune system and magic

### 🆕 **Modern Enhancements**
- ✅ **Event System**: Zombie events with rewards
- ✅ **Ranking System**: Competitive leaderboards
- ✅ **GM Tools**: Advanced administration
- ✅ **QoL Features**: Reduced spam, better UX
- ✅ **Mount System**: 20+ mounts with easy management

### 🎯 **Player Commands**
```
!highscore [category]  - View rankings (level, exp, skills, etc.)
!joinzombie           - Join zombie survival events  
!frags                - Check your PK statistics
!uptime               - Server uptime information
!deathlist            - View recent deaths
```

### 👨‍💼 **GM Commands**
```
/zombieevent [action] - Manage zombie events
/mount [player] [id]  - Give mounts to players
/mounts               - List available mounts
/ghost                - Enhanced invisibility mode
```

---

## 📊 Development Status

### ✅ **Completed Systems**
- **Core Engine**: TFS 1.2 with 8.60 features *(100%)*
- **Map & Quests**: All major content implemented *(95%)*
- **Event System**: Full zombie event functionality *(100%)*
- **Ranking System**: Complete highscore implementation *(100%)*
- **GM Tools**: Advanced administration suite *(100%)*
- **NPC Systems**: TFS 1.2 compatibility fixes *(100%)*

### 🚧 **In Progress**
- **Magic System**: Spell updates and balancing *(85%)*
- **Quest Refinements**: Minor quest bug fixes *(90%)*
- **Items 8.60**: Complete item database *(80%)*
- **Mount System**: Additional mount varieties *(95%)*

### 🔮 **Planned Features**
- **RevScript System**: Modern scripting architecture
- **Advanced Events**: More event types and mechanics
- **Enhanced PvP**: Tournament systems
- **Custom Areas**: New hunting grounds

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 **Bug Reports**
- Use GitHub Issues for bug reports
- Include detailed reproduction steps
- Attach relevant logs or screenshots

### 💡 **Feature Suggestions**
- Discuss ideas in GitHub Discussions
- Consider compatibility with 8.60 theme
- Provide detailed implementation ideas

### 🔧 **Code Contributions**
- Fork the repository
- Create feature branches
- Submit pull requests with clear descriptions
- Follow existing code style

---

## 📞 Support & Community

### 🔗 **Resources**
- **Documentation**: [TFS 1.2 Wiki](https://github.com/otland/forgottenserver/wiki)
- **Client**: [OTClient V8 Realmap](https://github.com/Brunowots/OTClient-V8-Realmap)
- **Forums**: [OTLand Community](https://otland.net/)

### ⚠️ **Known Issues**
- Minor visual map bugs (being fixed regularly)
- Some 8.60 items may need database updates
- Attack velocity SQM bug (planned fix)

### 🏷️ **Version Info**
- **Current Version**: Enhanced Edition v2.0
- **Base**: TFS 1.2 with 8.60 features
- **Last Update**: October 2025
- **Compatibility**: Tibia 8.0-8.6 clients

---

## 📜 License & Credits

### 👥 **Credits**
- **Original TFS Team**: The Forgotten Server development
- **Map Authors**: Global map contributors
- **Enhancement Developer**: Advanced features and TFS 1.2 updates
- **Community**: Bug reports and suggestions

### 📄 **License**
This project is open source and available under the MIT License. See LICENSE file for details.

---

<div align="center">

**🌟 Experience the Golden Age of Tibia with Modern Excellence 🌟**

*Join thousands of players in the most authentic and enhanced 8.60 experience available*

[![GitHub Stars](https://img.shields.io/github/stars/Javiieer/Darktibia860?style=social)](https://github.com/Javiieer/Darktibia860)
[![GitHub Forks](https://img.shields.io/github/forks/Javiieer/Darktibia860?style=social)](https://github.com/Javiieer/Darktibia860/fork)

</div> 