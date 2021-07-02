Representation of 3D vectors and points.

This structure is used throughout Atomontage to pass 3D positions and directions around. It also contains functions for doing common vector operations.

:::tip My tip

Wwo!!

:::

:::danger Take care

This action is dangerous

:::

## List of Methods

### vec3 ()
Returns Vec3(0, 0, 0).

```lua
local vec = Vec3()
```

### vec3 (float, float, float)
```lua
local vec = Vec3(0.5, 10, 33.33)
```

### vec3 (int32_t, int32_t, int32_t)
bablalal lablabl bl albl al bl ab

![Docusaurus logo](/img/docusaurus.png)

ahsjdhakshdjkasjdk

### vec3 (float)
dasdjalsdjljks

### vec4 __mul (Mat4, vec3)

### vec3 __mul (vec3, float)
Metamethod overload to multiply vec3 with float number 
```lua
local vec = Vec3(0, 10, 0)
local res = vec * 3 --res is Vec3(0, 30, 0)
```

### vec3 __mul (float, vec3)

### vec3 __mul (vec3, vec3)

### vec3 __div (vec3, float)

### float Dot (vec3, vec3)

### vec3 Lerp (vec3, vec3, float)

### vec3 Mix (vec3, vec3, float)

### void Normalize (vec3)
aaasss
Let $f:[a,b] \to \R$ be Riemann integrable. Let $F:[a,b]\to\R$ be $F(x)=
\int_{a}^{x}f(t)dt$. Then $$F$$ is continuous, and at all $x$ such that $f$ is continuous at $x$, $F$ is differentiable at $x$ with $F'(x)=f(x)$.

### vec3 GetNormalized (vec3)

### void Clamp (vec3, float, float)

### float Length (vec3)

## List of Properties

### float x
The x component of the vector
```lua
local x = vec.x
```

### float y

### float z

### vec3 zero
![Docusaurus logo](/img/docusaurus.png)

### vec3 up

### vec3 right

### vec3 forward

### float length

### vec3 normalized

