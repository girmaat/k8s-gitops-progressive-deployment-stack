# Gatekeeper Policies

OPA/Gatekeeper ConstraintTemplates and Constraints for cluster policy enforcement.

---

## Table of Contents
- [Block Image Tags](#block-image-tags)
- [Require Team Label](#require-team-label)
- [Structure](#structure)

---

## Block Image Tags

- Blocks deployments using `image:latest`.

## Require Team Label

- Ensures all workloads have a `team` label to indicate ownership.

##Structure

- `templates/`: Gatekeeper Rego logic (ConstraintTemplates)
- `constraints/`: Constraints applying policies to resources
