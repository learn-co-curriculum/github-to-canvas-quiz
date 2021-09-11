---
id: 126509
type: multiple_choice_question
---

# Functions: Scope

Which variables does the function `inner2` have access to?

```
const part1 = 'hello'

function demoChain(name) {
    let part2 = 'hi'
    return function inner1() {
        let part3 = 'there'
        return function inner2() {
            console.log(`${part1.toUpperCase()} ${part2} ${name}`);
        }
    }
}

demoChain("Dr. Stephen Strange")()()

//=> HELLO hi Dr. Stephen Strange
```

> **Source/s: ** [Functions: Continued](https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565)
