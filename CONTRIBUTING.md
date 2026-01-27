# Contributing to OpenXS Video Downloader

Thank you for your interest in contributing to OpenXS Video Downloader! This document provides guidelines and information for contributors.

## How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use the issue templates** when available
3. **Provide detailed information**:
   - Operating system and version
   - Qt version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

### Suggesting Features

1. **Check existing feature requests** to avoid duplicates
2. **Describe the use case** and why it would be valuable
3. **Consider implementation complexity** and maintenance burden
4. **Provide mockups or examples** if applicable

### Code Contributions

#### Getting Started

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/OpenXS-gui-for-yt_dlp.git
   cd OpenXS-gui-for-yt_dlp
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Development Setup

1. **Install dependencies**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

2. **Build and test**:
   ```bash
   chmod +x openxs.sh
   ./openxs.sh build
   ./openxs.sh run
   ```

#### Code Style

- **C++**: Follow Qt coding conventions
- **Shell Scripts**: Use bash best practices
- **JSON**: Maintain proper formatting and validation
- **Comments**: Write clear, concise comments for complex logic

#### Testing

- **Test on multiple distributions** when possible
- **Verify wizard flow** works correctly
- **Test edge cases** (invalid URLs, network issues, etc.)
- **Check desktop integration** (menu entries, icons)

#### Commit Guidelines

- **Use conventional commits**: `type(scope): description`
- **Types**: feat, fix, docs, style, refactor, test, chore
- **Examples**:
  - `feat(wizard): add subtitle language selection`
  - `fix(installer): handle missing dependencies gracefully`
  - `docs(readme): update installation instructions`

#### Pull Request Process

1. **Update documentation** if needed
2. **Add tests** for new features
3. **Ensure CI passes** (GitHub Actions)
4. **Request review** from maintainers
5. **Address feedback** promptly

### Package Maintenance

#### AUR Package
- Located in `packaging/arch/PKGBUILD`
- Test with `makepkg -si`
- Update version and checksums for releases

#### Flatpak
- Manifest in `packaging/flatpak/org.openxs.VideoDownloader.yml`
- Test with `flatpak-builder`
- Follow Flathub guidelines

#### Snap
- Configuration in `packaging/snap/snapcraft.yaml`
- Test with `snapcraft`
- Ensure confinement works properly

#### AppImage
- Build script in `packaging/appimage/build-appimage.sh`
- Test on multiple distributions
- Verify all dependencies are bundled

## Development Guidelines

### Architecture

- **Main Application**: Qt5/C++ GUI with wizard interface
- **Configuration**: JSON-based with schema validation
- **Backend**: yt-dlp integration via QProcess
- **Installation**: Multi-platform shell script

### Adding New Features

1. **Update configuration schema** if needed
2. **Add wizard page** for user interaction
3. **Implement backend logic** in main application
4. **Update documentation** and help text
5. **Test thoroughly** across platforms

### Modifying the Wizard

- Each step should be **simple and focused**
- **Validate input** before proceeding
- **Provide helpful tooltips** and examples
- **Maintain consistent UI/UX**

### Configuration Changes

- **Update schema** in `openxs_config.json`
- **Maintain backward compatibility** when possible
- **Document breaking changes** in release notes
- **Test configuration validation**

## Release Process

### Version Numbering

- Follow **semantic versioning** (MAJOR.MINOR.PATCH)
- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, backward compatible

### Creating Releases

1. **Update version** in relevant files
2. **Update CHANGELOG.md** with changes
3. **Create and push tag**: `git tag v2.1.0`
4. **GitHub Actions** will build and create release
5. **Update package repositories** (AUR, Flatpak, etc.)

## Community Guidelines

### Code of Conduct

- **Be respectful** and inclusive
- **Help newcomers** learn and contribute
- **Focus on constructive feedback**
- **Assume good intentions**

### Communication

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Pull Requests**: Code review and collaboration

## Getting Help

- **Documentation**: Check README.md and docs/
- **Issues**: Search existing issues for solutions
- **Discussions**: Ask questions in GitHub Discussions
- **Code**: Read existing code for examples

## Recognition

Contributors will be:
- **Listed in CONTRIBUTORS.md**
- **Mentioned in release notes** for significant contributions
- **Credited in commit messages** and pull requests

Thank you for contributing to OpenXS Video Downloader!