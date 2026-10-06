---
name: derek-design-preferences
description: Apply Derek's UI copy and typography preferences when building or refining app pages and components. Favor useful copy, native system fonts, and restrained font weights.
---

# Derek's design preferences

- Do not add eyebrow text: small overlines, category labels, or decorative captions above a heading. Remove existing eyebrows when refining a page.
- Remove descriptions that add no actionable information. Avoid mood-setting slogans, generic reassurance, and sentences that merely narrate the page or repeat its heading. For example, delete “A list, a task, a project. Start with how they feel.” without replacing it with another slogan.
- Keep text that helps someone act or understand actual state: control labels, necessary interaction instructions, meaningful empty states, validation, and consequences such as “Changes reset on refresh.”

For each description, ask: would removing it make the task harder to complete or the state harder to understand? If not, omit it. A heading can stand on its own.

## Landing pages and supporting copy

- Avoid scattering taglines around the interface: navigation captions, text below calls to action, preview captions, and footer slogans should earn their space by conveying useful information. Recent removals included “A little more clarity,” “Your tasks. Your pace,” and “Small steps. A clearer picture.” Do not replace removed copy with equivalent filler.
- Keep consumer pages focused on the product. Omit implementation-facing links such as “Explore the data model” unless the intended audience needs them. This is not a blanket ban on technical links in developer products.
- Remove only the requested portion of mixed-purpose copy. A decorative preview slogan can go while a useful interaction hint remains.

## Typography

- Prefer native system typography when choosing a new default. The Atoms home page uses `font-family: -apple-system, system-ui, 'SF Pro Display', sans-serif`. Preserve an explicitly chosen font or established project requirement rather than changing unrelated typography automatically.
- Favor regular body text and medium (500) headings and labels, using spacing and size to establish hierarchy. Derek prefers no font weights above semibold (600) across UI designs, including headings, bold elements, and font utilities. Treat 600 as the maximum unless he explicitly requests otherwise.
- Derek cares about crisp rendering across platforms. Check readability with the actual platform font; do not assume macOS smoothing declarations improve Windows rendering. Suggestions from an assistant, such as increasing every small label's size, are not established preferences until Derek adopts them.
