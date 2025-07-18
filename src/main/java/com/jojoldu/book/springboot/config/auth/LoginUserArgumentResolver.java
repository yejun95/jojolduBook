package com.jojoldu.book.springboot.config.auth;

import com.jojoldu.book.springboot.config.auth.dto.SessionUser;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import javax.servlet.http.HttpSession;

@RequiredArgsConstructor
@Component
public class LoginUserArgumentResolver implements HandlerMethodArgumentResolver {

    private final HttpSession httpSession;

    /*
    어노테이션이 붙은 파라미터에 실제 User 객체를 주입하려면 → HandlerMethodArgumentResolver 필요 (ex: @LoginUser SessionUser user)
    단순 마킹/검증/AOP → HandlerMethodArgumentResolver 불필요
     */

    /**
     * 1. 컨트롤러 메서드의 특정 파라미터를 지원하는지 판단
     * 2. 여기서는 파라미터에 @LoginUser 어노테이셔닝 붙어 있고, 파라미터 클래스 타입이
     *    SessionUser.class인 경우 true를 반환
     */
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        boolean isLoginUserAnnotation = parameter.getParameterAnnotation(LoginUser.class) != null;
        boolean isUserClass = SessionUser.class.equals(parameter.getParameterType());

        return isLoginUserAnnotation && isUserClass;
    }

    /**
     * 1. 파라미터에 전달한 객체를 생성
     * 2. 여기서는 세션에서 객체를 가져옴
     */
    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        return httpSession.getAttribute("user");
    }
}
