package com.antigravity.fcms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.beans.factory.annotation.Value;

/**
 * Spring MVC configuration for FCMS.
 *
 * <p>Registers the JSP view resolver with the correct prefix/suffix,
 * maps the webapp static directory as a resource handler so that
 * CSS and JS files are served correctly, and configures the root
 * redirect to the landing page.</p>
 *
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${spring.mvc.view.prefix:/WEB-INF/views/}")
    private String viewPrefix;

    @Value("${spring.mvc.view.suffix:.jsp}")
    private String viewSuffix;

    /**
     * Configures the JSP view resolver.
     * Sets the prefix to /WEB-INF/views/ and suffix to .jsp.
     *
     * @param registry the view resolver registry
     */
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp(viewPrefix, viewSuffix);
    }

    /**
     * Maps root "/" to redirect to the landing page.
     * This ensures visitors see the public landing page by default.
     *
     * @param registry the view controller registry
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addRedirectViewController("/", "/landing.html");
    }

    /**
     * Maps the /static/** URL path to serve files from the webapp
     * static directory as well as the classpath static location.
     *
     * @param registry the resource handler registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations(
                        "/static/",
                        "classpath:/static/"
                );
        registry.addResourceHandler("/modules/**")
                .addResourceLocations("/modules/");
    }
}
