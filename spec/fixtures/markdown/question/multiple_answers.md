---
course_id: 3264
quiz_id: 18302
id: 123916
type: multiple_answers_question
---

# Exporting

I want to render the Card component inside of my Container component. How would
I properly export the Card component?

```jsx
function Card({ title, subtitle }) {
  return (
    <div>
      <h1>{title}</h1>
      <p>{subtitle}</p>
    </div>
  );
}
```

## Correct

```jsx
function Card({ title, subtitle }) { ... }

export default Card;
```

## Correct

```jsx
export default function Card({ title, subtitle }) { ... }
```

## Incorrect

```jsx
function Card({ title, subtitle }) { ... }
export cardComponent;
```

> Be sure you are exporting the correct function!

## Incorrect

I don't know.
