import React, { useState, useRef, useEffect } from "react";

export const Logo = ({ variant = "large", alwaysTrack = false }) => {
    const isLarge = variant === "large";
    const containerRef = useRef(null);
    const [mousePos, setMousePos] = useState({ x: 0, y: 0 });
    const [isHovering, setIsHovering] = useState(false);
    const [clicked, setClicked] = useState(false);

    useEffect(() => {
        const container = containerRef.current;
        if (!container) return;

        const target = alwaysTrack ? window : container;

        const handleMouseMove = (e) => {
            const rect = container.getBoundingClientRect();

            // Calculate center of the container
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;

            // Calculate distance from center
            const dx = e.clientX - centerX;
            const dy = e.clientY - centerY;

            setMousePos({ x: dx, y: dy });
        };

        const handleMouseEnter = () => setIsHovering(true);
        const handleMouseLeave = () => {
            setIsHovering(false);
            if (!alwaysTrack) {
                setMousePos({ x: 0, y: 0 });
            }
        };

        target.addEventListener("mousemove", handleMouseMove);
        if (!alwaysTrack) {
            container.addEventListener("mouseenter", handleMouseEnter);
            container.addEventListener("mouseleave", handleMouseLeave);
        }

        return () => {
            target.removeEventListener("mousemove", handleMouseMove);
            if (!alwaysTrack) {
                container.removeEventListener("mouseenter", handleMouseEnter);
                container.removeEventListener("mouseleave", handleMouseLeave);
            }
        };
    }, [isHovering, alwaysTrack]);

    const handleClick = () => {
        setClicked(true);
        setTimeout(() => setClicked(false), 600);
    };

    const mainText = "Monitor Minder";
    const subText = "noah's website";

    const getLetterTransform = (index, totalLetters) => {
        const tracking = alwaysTrack || isHovering;

        if (!tracking) return { x: 0, y: 0, scale: 1, rotate: 0 };

        const letterWidth = isLarge ? 20 : 14;
        // Calculate the initial X position of this letter relative to center
        const letterX = (index - totalLetters / 2 + 0.5) * letterWidth;

        // Distance from mouse to this specific letter's original position
        const dx = mousePos.x - letterX;
        const dy = mousePos.y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        const maxDistance = 200; // Slightly increased range for better responsiveness

        if (distance < maxDistance) {
            // Magnetic effect: pull towards mouse
            // Use a bell curve for smoother falloff
            const force = Math.exp(-(distance * distance) / (2 * 80 * 80)); // Wider standard deviation (80px) for smoother feel

            const pullStrength = 8; // Slightly increased pull
            const pullX = (dx / distance) * force * pullStrength;
            const pullY = (dy / distance) * force * pullStrength;

            const scale = 1 + force * 0.1; // Gentle scale
            const rotate = (dx / distance) * force * 4; // Gentle rotation

            return { x: pullX, y: pullY, scale, rotate };
        }

        return { x: 0, y: 0, scale: 1, rotate: 0 };
    };

    const tracking = alwaysTrack || isHovering;

    return (
        <div
            ref={containerRef}
            onClick={handleClick}
            style={{
                position: "relative",
                display: "inline-flex", // changed from flex to inline-flex
                flexDirection: "column",
                alignItems: "flex-start", // align left
                cursor: "pointer",
                userSelect: "none",
                padding: "1rem 0", // reduced padding
                transition: "transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)",
                transformStyle: "preserve-3d",
                transform: clicked ? "scale(0.95)" : "scale(1)",
            }}
        >
            {/* Main text */}
            <div
                style={{
                    fontSize: isLarge ? "4rem" : "2.5rem", // Much bigger
                    fontWeight: "600", // Bolder
                    display: "flex",
                    position: "relative",
                    letterSpacing: tracking ? "0.02em" : "-0.02em", // Tighter default spacing for impact
                    transition: "letter-spacing 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)",
                    fontFamily: "var(--font-main)",
                    lineHeight: "1", // Tight line height
                }}
            >
                {mainText.split("").map((char, i) => {
                    const transform = getLetterTransform(i, mainText.length);
                    return (
                        <span
                            key={i}
                            style={{
                                display: "inline-block",
                                transition: "all 0.15s cubic-bezier(0.2, 0.8, 0.2, 1)", // Smoother spring-like easing
                                transform: `translate(${transform.x}px, ${transform.y}px) scale(${transform.scale}) rotate(${transform.rotate}deg)`,
                                color: 'var(--color-text)',
                                textShadow: tracking
                                    ? `0 0 15px rgba(0, 0, 0, ${transform.scale * 0.1})`
                                    : "none",
                                filter: `blur(${Math.max(0, (1 - transform.scale) * 2)}px)`,
                            }}
                        >
                            {char === " " ? "\u00A0" : char}
                        </span>
                    );
                })}
            </div>

            {/* Subtitle */}
            <div
                style={{
                    fontSize: isLarge ? "1rem" : "0.8rem",
                    color: "#666", // Grey
                    marginTop: "0.5rem",
                    transition: "all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)",
                    transform: `translateX(${mousePos.x * 0.05}px) translateY(${mousePos.y * 0.05}px)`,
                    letterSpacing: tracking ? "0.05em" : "0",
                    fontStyle: "italic",
                }}
            >
                {subText}
            </div>
        </div>
    );
};
