# Contributor Covenant Code of Conduct

## Our Pledge
We pledge to make participation in our community harassment-free, open, welcoming, and inclusive.

## Our Standards
- Be respectful and constructive
- Show empathy and kindness
- No harassment, trolling, or abusive behavior

## Enforcement
Report unacceptable behavior privately at: [INSERT CONTACT EMAIL].

## Attribution
Adapted from [Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct.html).
EOF

cat > SECURITY.md <<'EOF'
# Security Policy

## Supported Versions
Only the latest release of **wspr-ai-lite** is actively supported.

## Reporting Vulnerabilities
Please report security issues **privately**:
- 📧 [INSERT CONTACT EMAIL]

Do **not** open a public GitHub Issue.

Provide:
- Steps to reproduce
- Impact assessment
- Affected versions

We acknowledge within 7 days, patch within 30 days.

## Disclosure
Once fixed, we will:
- Publish a patched release
- Update the CHANGELOG
- Credit reporters if desired
EOF

# Package them
tar -czf governance-files.tar.gz CODE_OF_CONDUCT.md SECURITY.md
