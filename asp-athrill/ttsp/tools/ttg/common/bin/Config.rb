#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: Config.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "ttc/bin/class/TTCCommon.rb"

module CommonModule
  #===================================================================
  # ���饹̾: Config
  # ����  ��: ��������
  #===================================================================
  class Config
    include CommonModule
    include TTCModule

    @@hConf = {}  # configure����

    #=================================================================
    # ������: configure�ե�������ɤ߹���
    #=================================================================
    def load_config(sFileName)
      check_class(String, sFileName)  # configure�ե�����

      hConf = load_yaml_file(sFileName)
      # Hash�ʤ����Ȥ�set���Ƥ���
      if (hConf.is_a?(Hash))
        hConf.each{|sKey, val|
          # �������ꤵ��Ƥ�����ܤ����Ф�
          if (@@hConf[sKey].nil?())
            set(sKey, val)
          end
        }
      ### T0_008: configure��Hash�Ǥʤ�
      else
        sErr = sprintf("T0_008: " + ERR_INVALID_TYPE, "configure", Hash, hConf.class())
        raise(TTCError.new(sErr))
      end

      # �ޥ�����ͤ�׻�����
      calc_macro()
    end

    #=================================================================
    # ������: �ͤ����ꤹ��
    #=================================================================
    def set(sKey, val)
      check_class(String, sKey)       # ����
      check_class(Object, val, true)  # ��

      # 16�ʿ�����
      if (val =~ TTC_REX_HEX)
        val = val.hex()
      end

      case sKey
      # ʸ����
      when CFG_FILE, CFG_DEFAULT_CLASS, CFG_OUT_FILE, CFG_TIME_MANAGE_CLASS, CFG_EXCEPT_ARG_NAME
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        unless (val.is_a?(String))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # ������
      when CFG_TEST_FLOW, CFG_DEBUG_MODE, CFG_STACK_SHARE, CFG_ALL_GAIN_TIME,
           CFG_OWN_IPI_RAISE, CFG_ENA_EXC_LOCK, CFG_ENA_CHGIPM,
           CFG_FUNC_TIME, CFG_FUNC_INTERRUPT, CFG_FUNC_EXCEPTION,
           CFG_NO_PROGRESS_BAR, CFG_ENABLE_GCOV, CFG_ENABLE_LOG, CFG_ENABLE_TTJ,
           CFG_SUPPORT_GET_UTM, CFG_SUPPORT_ENA_INT, CFG_SUPPORT_DIS_INT
        val = to_bool(val)
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        unless (Bool.include?(val.class()))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # 0����礭������
      when CFG_MAIN_PRCID, CFG_PRC_NUM, CFG_TIME_MANAGE_PRCID
        # ���ץ����������ʸ����ˤʤ뤿���Ѵ�
        if (val =~ TTC_REX_NUM)
          val = val.to_i()
        end
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(Integer))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val <= 0)
          sErr = sprintf("T0_003: " + ERR_CFG_BE_INTEGER_GT, sKey, 0, val)
          raise(TTCError.new(sErr))
        end

      # 0�ʾ������
      when CFG_SPINLOCK_NUM, CFG_WAIT_SPIN_LOOP
        # ���ץ����������ʸ����ˤʤ뤿���Ѵ�
        if (val =~ TTC_REX_NUM)
          val = val.to_i()
        end
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(Integer))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val < 0)
          sErr = sprintf("T0_003: " + ERR_CFG_BE_INTEGER_GE, sKey, 0, val)
          raise(TTCError.new(sErr))
        end

      # ʸ����0��꾮��������
      when CFG_TIMER_INT_PRI
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(String) && !val.is_a?(Integer))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val.is_a?(Integer) && (val >= 0))
          sErr = sprintf("T0_003: " + ERR_CFG_BE_INTEGER_LT, sKey, 0, val)
          raise(TTCError.new(sErr))
        end

      # �ץ�ե�����
      when CFG_PROFILE
        # ���ץ������Ϥ�ͭ���ͤ�����å�����

      # �����ޥ������ƥ�����
      when CFG_TIMER_ARCH
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(String))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val != TSR_PRM_TIMER_GLOBAL && val != TSR_PRM_TIMER_LOCAL)
          sErr = sprintf("T0_003: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # IRC�������ƥ�����
      when CFG_IRC_ARCH
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(String))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val != TSR_PRM_IRC_GLOBAL && val != TSR_PRM_IRC_LOCAL && val != TSR_PRM_IRC_COMBINATION)
          sErr = sprintf("T0_003: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # YAML�饤�֥��
      when CFG_YAML_LIBRARY
        ### T0_002: configure�������ͤ����ꤵ�줿���Ȱۤʤ�
        if (!val.is_a?(String))
          sErr = sprintf("T0_002: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        ### T0_003: configure�������ͤ�ͭ���ͤǤʤ�
        elsif (val != CFG_LIB_YAML && val != CFG_LIB_KWALIFY)
          sErr = sprintf("T0_003: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # �ޥ���
      when CFG_MACRO
        ### T0_009: �ޥ����������Hash�Ǥʤ�
        unless (val.nil?() || val.is_a?(Hash))
          sErr = sprintf("T0_009: " + ERR_CFG_INVALID_VALUE, sKey, val)
          raise(TTCError.new(sErr))
        end

      # �������Ƥ��ʤ�����
      else
        ### T0_010: configure�˵��ꤵ��Ƥ��ʤ����ܤ����Ҥ���Ƥ���
        sErr = sprintf("T0_010: " + ERR_CFG_UNDEFINED_KEY, sKey, "configure")
        raise(TTCError.new(sErr))
      end

      # �����å����̤������
      @@hConf[sKey] = val
    end

    #=================================================================
    # ������: �ޥ�����ͤ����
    #=================================================================
    def calc_macro()
      if (@@hConf[CFG_MACRO].is_a?(Hash))
        hMacro = @@hConf.dup()
        hMacro.delete(CFG_MACRO)
        @@hConf[CFG_MACRO].each{|sMacro, val|
          @@hConf[CFG_MACRO][sMacro] = parse_value(val, hMacro)
        }
      end
    end

    #=================================================================
    # ������: �����ͤ�ɽ��ʸ������Ѵ�����
    #=================================================================
    def to_bool(sStr)
      check_class(Object, sStr, true)  # �Ѵ�����ʸ����

      case sStr
      when "true"
        return true # [Bool]�Ѵ����
      when "false"
        return false # [Bool]�Ѵ����
      else
        return safe_dup(sStr) # [Bool]�Ѵ����
      end
    end

    #=================================================================
    # ������: configure�Υ����å���Ԥ�
    #=================================================================
    def environment_check()
      @aErrors = []

      # ����Υ����å�
      GRP_CFG_NECESSARY_KEYS.each{|sKey|
        ### T0_001: configure������ǵ��Ҥ���Ƥ��ʤ����ܤ�����
        unless (@@hConf.has_key?(sKey))
          sErr = sprintf("T0_001: " + ERR_CFG_REQUIRED_KEY, sKey)
          @aErrors.push(TTCError.new(sErr))
        end
      }

      # �ޥ���Υ����å�
      hMacro = get_macro()
      hBitPattern = Hash.new{|hash, key|
        hash[key] = {}
      }

      ### T0_007: ɬ�פʥޥ����������Ƥ��ʤ�
      GRP_CFG_NECESSARY_MACRO.each{|sMacro|
        if (hMacro.nil?() || !hMacro.has_key?(sMacro))
          sErr = sprintf("T0_007: " + ERR_CFG_REQUIRED_MACRO, sMacro)
          @aErrors.push(TTCError.new(sErr))
        end
      }

      if (hMacro.is_a?(Hash))
        ### T0_004: �ޥ���������ͤ����ꤵ�줿���Ȱۤʤ�
        ### T0_005: �ޥ���������ͤ�ͭ���ͤǤʤ�
        hMacro.each{|sMacro, val|
          case sMacro
          # [0����礭������]
          when /^PRC_/, "MAIN_PRCID", "ANY_INI_BLKCNT", "ANY_NOW_BLKCNT", "ANY_BLKSZ", "ANY_MAX_SEMCNT", "ANY_NOW_SEMCNT"
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val <= 0)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_GT, sMacro, 0, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [ʸ����]
          when /^CLS_/
            unless (val.is_a?(String))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, String, val.class())
              @aErrors.push(TTCError.new(sErr))
            end

          # [1����4���ϰϤ�����]
          when "TSK_PRI_LE_4", "TSK_PRI_LE_LE_4"
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val < 1 || val > 4)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_RANGE, sMacro, 1, 4, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [13����16���ϰϤ�����]
          when "TSK_PRI_GE_13"
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val < 13 || val > 16)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_RANGE, sMacro, 13, 16, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [0�ʾ������]
          when /^BIT_PATTERN_/, /^TEXPTN_/
            nVal = parse_value(val)
            unless (nVal.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            end
            # 0�Ǥ�����
            if (nVal == 0 && sMacro =~ /^(BIT_PATTERN|TEXPTN)_[^0]/)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_NE, sMacro, 0, val)
              @aErrors.push(TTCError.new(sErr))
            end
            # �ӥåȥ�ˡ���Ƚ����
            if (sMacro =~ /^BIT_PATTERN_/)
              hBitPattern[:hBitPtn][sMacro] = nVal
            elsif (sMacro =~ /^TEXPTN_/)
              hBitPattern[:hTexPtn][sMacro] = nVal
            end

          # [TWF_ANDW��TWF_ORW]
          when /^WAIT_FLG_MODE_/
            unless (val == KER_TWF_ANDW || val == KER_TWF_ORW)
              sErr = sprintf("T0_005: " + ERR_MCR_INVALID_VALUE, sMacro, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [0�ʾ������]
          when "ANY_INI_SEMCNT", /^RELATIVE_/
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val < 0)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_GE, sMacro, 0, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [1����16������]
          when /^TSK_PRI_/, /^DATA_PRI_/, /^MSG_PRI_/, /^ISR_PRI_/
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val < 1 || val > 16)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_RANGE, sMacro, 1, 16, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [0����礭������]
          when /_TIME$/
            if (!val.is_a?(Integer))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, Integer, val.class())
              @aErrors.push(TTCError.new(sErr))
            elsif (val <= 0)
              sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_GE, sMacro, 0, val)
              @aErrors.push(TTCError.new(sErr))
            end

          # [ʸ����0��꾮��������]
          when /^ANY_IPM/, /^INT_PRI_/
            unless (val.is_a?(String))
              if (!val.is_a?(Integer))
                sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, "Integer or String", val.class())
                @aErrors.push(TTCError.new(sErr))
              elsif (val >= 0)
                sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_LT, sMacro, 0, val)
                @aErrors.push(TTCError.new(sErr))
              end
            end

          # [ʸ����0�ʾ������]
          when /^INTNO_/, /^INHNO_/, /^EXCNO_/, /^ANY_/
            unless (val.is_a?(String))
              if (!val.is_a?(Integer))
                sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, "Integer or String", val.class())
                @aErrors.push(TTCError.new(sErr))
              elsif (val < 0)
                sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_GE, sMacro, 0, val)
                @aErrors.push(TTCError.new(sErr))
              end
            end

          # [ʸ��������]
          when /^DATA_/, /^EXINF_/
            if (!val.is_a?(Integer) && !val.is_a?(String))
              sErr = sprintf("T0_004: " + ERR_MCR_INVALID_TYPE, sMacro, "Integer or String", val.class())
              @aErrors.push(TTCError.new(sErr))
            end
          end
        }
        check_error(@aErrors)

        # ��¸�ط��Υ����å�
        check_priority("TSK_PRI_LOW", "TSK_PRI_MID", "TSK_PRI_HIGH")
        check_le("TSK_PRI_LE_LE_4", "TSK_PRI_LE_4")
        check_le("TSK_PRI_LE_GE_13", "TSK_PRI_GE_13")
        check_priority("DATA_PRI_LOW", "DATA_PRI_MID", "DATA_PRI_HIGH", "DATA_PRI_MAX")
        check_priority("MSG_PRI_LOW", "MSG_PRI_MID", "MSG_PRI_HIGH", "MSG_PRI_MAX")
        check_priority("ISR_PRI_LOW", "ISR_PRI_MID", "ISR_PRI_HIGH")
        check_le("ANY_NOW_BLKCNT", "ANY_INI_BLKCNT")
        check_le("ANY_INI_SEMCNT", "ANY_MAX_SEMCNT")
        check_lt("ANY_NOW_SEMCNT", "ANY_MAX_SEMCNT")
        check_bit_unique(hBitPattern[:hBitPtn])
        check_bit_unique(hBitPattern[:hTexPtn])
      end

      ### T0_006: �������ؿ����ʤ��Τ����ƥ��ȥ�����������߻���Ǥ���
      if (!is_all_gain_time_mode?() && get_func_time() == false)
        @aErrors.push(TTCError.new("T0_006: " + ERR_VARIATION_TIME_GAIN))
      end

      check_error(@aErrors)
    end

    #=================================================================
    # ������: ͥ���٤ΰ�¸�ط������å���Ԥ�
    #=================================================================
    def check_priority(sLow, sMid, sHigh, sMax = nil)
      check_class(String, sLow)        # LOW
      check_class(String, sMid)        # MID
      check_class(String, sHigh)       # HIGH
      check_class(String, sMax, true)  # MAX

      hMacro = get_macro()
      # ������
      unless (hMacro[sMax].nil?())
        check_le(sLow, sMax)
        check_le(sMid, sMax)
        check_le(sHigh, sMax)
      end

      # �羮�ط�
      check_lt(sMid, sLow)
      check_lt(sHigh, sMid)
      check_lt(sHigh, sLow)
    end

    #=================================================================
    # ������: �羮�ط������å���Ԥ�
    #=================================================================
    def check_le(sKey1, sKey2)
      check_class(String, sKey1, true)  # ���Ȥʤ��ͤΥ���
      check_class(String, sKey2, true)  # ����оݤΥ���

      hMacro = get_macro()
      if (hMacro[sKey1] > hMacro[sKey2])
        sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_LE, sKey1, sKey2, hMacro[sKey2])
        @aErrors.push(TTCError.new(sErr))
      end
    end

    #=================================================================
    # ������: �羮�ط������å���Ԥ�
    #=================================================================
    def check_lt(sKey1, sKey2)
      check_class(String, sKey1, true)  # ���Ȥʤ��ͤΥ���
      check_class(String, sKey2, true)  # ����оݤΥ���

      hMacro = get_macro()
      if (hMacro[sKey1] >= hMacro[sKey2])
        sErr = sprintf("T0_005: " + ERR_MCR_BE_INTEGER_LT, sKey1, sKey2, hMacro[sKey2])
        @aErrors.push(TTCError.new(sErr))
      end
    end

    #=================================================================
    # ������: �ӥåȥ�ˡ��������å���Ԥ�
    #=================================================================
    def check_bit_unique(hBitPattern)
      check_class(Hash, hBitPattern)  # �ӥåȥѥ��������äƤ�������

      nTmp = 0
      hBitPattern.each{|sMacro, nVal|
        if (nTmp & nVal != 0)
          sErr = sprintf("T0_005: " + ERR_MCR_NOT_BIT_UNIQUE, sMacro)
          @aErrors.push(TTCError.new(sErr))
        end
        nTmp = nTmp | nVal
      }
    end

    #=================================================================
    # ������: �ɤ߹���configure�ե�����̾�����
    #=================================================================
    def get_configure_file()
      return @@hConf[CFG_FILE] # [String]configure�ե�����̾
    end

    #=================================================================
    # ������: ���ϥե�����̾�����
    #=================================================================
    def get_out_file()
      return @@hConf[CFG_OUT_FILE] # [String]���ϥե�����̾
    end

    #=================================================================
    # ������: �ǥե���ȥ��饹̾�����
    #=================================================================
    def get_default_class()
      return @@hConf[CFG_DEFAULT_CLASS] # [String]�ǥե���ȥ��饹̾
    end

    #=================================================================
    # ������: �ᥤ��ץ��å�ID�����
    #=================================================================
    def get_main_prcid()
      return @@hConf[CFG_MAIN_PRCID] # [Integer]�ᥤ��ץ��å�ID
    end

    #=================================================================
    # ������: �ץ��å��������
    #=================================================================
    def get_prc_num()
      return @@hConf[CFG_PRC_NUM] # [Integer]�ץ��å���
    end

    #=================================================================
    # ������: ���ԥ��å��������
    #=================================================================
    def get_spinlock_num()
      return @@hConf[CFG_SPINLOCK_NUM] # [Integer]���ԥ��å���
    end

    #=================================================================
    # ������: ���ԥ��å������Ԥ����ǧ���뤿��Υ롼�ײ�������
    #=================================================================
    def get_wait_spin_loop()
      return @@hConf[CFG_WAIT_SPIN_LOOP] # [Integer]���ԥ��å������Ԥ����ǧ���뤿��Υ롼�ײ��
    end

    #=================================================================
    # ������: �����ޥ������ƥ���������
    #=================================================================
    def get_timer_arch()
      return @@hConf[CFG_TIMER_ARCH] # [String]�����ޥ������ƥ�����
    end

    #=================================================================
    # ������: IRC�������ƥ���������
    #=================================================================
    def get_irc_arch()
      return @@hConf[CFG_IRC_ARCH] # [String]IRC�������ƥ�����
    end

    #=================================================================
    # ������: �����Х륿�����ѥ��饹�����
    #=================================================================
    def get_time_manage_class()
      return @@hConf[CFG_TIME_MANAGE_CLASS] # [String]�����Х륿�����ѥ��饹
    end

    #=================================================================
    # ������: �����ƥ��������ץ��å�ID�����
    #=================================================================
    def get_time_manage_prcid()
      return @@hConf[CFG_TIME_MANAGE_PRCID] # [Integer]�����ƥ��������ץ��å�ID
    end

    #=================================================================
    # ������: �桼������ޥ�������
    #=================================================================
    def get_macro()
      return @@hConf[CFG_MACRO] # [Hash]�ޥ���Υϥå���
    end

    #=================================================================
    # ������: �������ؿ������Ѳ�ǽ�����֤�
    #=================================================================
    def get_func_time()
      return @@hConf[CFG_FUNC_TIME] # [Bool]�������ؿ������Ѳ�ǽ��
    end

    #=================================================================
    # ������: �����ȯ���ؿ������Ѳ�ǽ�����֤�
    #=================================================================
    def get_func_interrupt()
      return @@hConf[CFG_FUNC_INTERRUPT] # [Bool]�����ȯ���ؿ������Ѳ�ǽ��
    end

    #=================================================================
    # ������: CPU�㳰ȯ���ؿ������Ѳ�ǽ�����֤�
    #=================================================================
    def get_func_exception()
      return @@hConf[CFG_FUNC_EXCEPTION] # [Bool]CPU�㳰ȯ���ؿ������Ѳ�ǽ��
    end

    #=================================================================
    # ������: ���ץ��å��ؤΥץ��å��ֳ���ߤ���ǽ�����֤�
    #=================================================================
    def get_own_ipi_raise()
      return @@hConf[CFG_OWN_IPI_RAISE] # [Bool]���ץ��å��ؤΥץ��å��ֳ���ߤ���ǽ��
    end

    #=================================================================
    # ������: CPU��å����CPU�㳰ȯ���򥵥ݡ��Ȥ��Ƥ��뤫���֤�
    #=================================================================
    def get_enable_exc_in_cpulock()
      return @@hConf[CFG_ENA_EXC_LOCK] # [Bool]CPU��å����CPU�㳰ȯ���򥵥ݡ��Ȥ��Ƥ��뤫
    end

    #=================================================================
    # ������: �󥿥�������ƥ����Ȥ���γ����ͥ���٥ޥ����ѹ��򥵥ݡ�
    #       : �Ȥ��Ƥ��뤫���֤�
    #=================================================================
    def get_enable_chg_ipm_in_non_task()
      return @@hConf[CFG_ENA_CHGIPM] # [Bool]���ݡ��Ȥ��Ƥ��뤫
    end

    #=================================================================
    # ������: CPU�㳰�ϥ�ɥ�ΰ����Ȥ����ѿ�̾�����
    #=================================================================
    def get_exception_arg_name()
      return @@hConf[CFG_EXCEPT_ARG_NAME] # [String]�����Ȥ����ѿ�̾
    end

    #=================================================================
    # ������: API��get_utm�򥵥ݡ��Ȥ��Ƥ��뤫���֤�
    #=================================================================
    def get_api_support_get_utm()
      return @@hConf[CFG_SUPPORT_GET_UTM] # [Bool]���ݡ��Ȥ��Ƥ��뤫
    end

    #=================================================================
    # ������: API��ena_int�򥵥ݡ��Ȥ��Ƥ��뤫���֤�
    #=================================================================
    def get_api_support_ena_int()
      return @@hConf[CFG_SUPPORT_ENA_INT] # [Bool]���ݡ��Ȥ��Ƥ��뤫
    end

    #=================================================================
    # ������: API��dis_int�򥵥ݡ��Ȥ��Ƥ��뤫���֤�
    #=================================================================
    def get_api_support_dis_int()
      return @@hConf[CFG_SUPPORT_DIS_INT] # [Bool]���ݡ��Ȥ��Ƥ��뤫
    end

    #=================================================================
    # ������: �����޳���ߤγ����ͥ���٤��֤�(�����Ի���)
    #=================================================================
    def get_timer_int_pri()
      return @@hConf[CFG_TIMER_INT_PRI] # [Bool]�����޳���ߤγ����ͥ����
    end

    #=================================================================
    # ������: �ƥ��ȥե��⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_testflow_mode?()
      return @@hConf[CFG_TEST_FLOW] # [Bool]�ƥ��ȥե��⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: �ǥХå��⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_debug_mode?()
      return @@hConf[CFG_DEBUG_MODE] # [Bool]�ǥХå��⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: �����å���ͭ�⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_stack_share_mode?()
      return @@hConf[CFG_STACK_SHARE] # [Bool]�����å���ͭ�⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: ���ƥ��ȥ��ʥꥪ�ǻ��֤�ʤ��⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_all_gain_time_mode?()
      return @@hConf[CFG_ALL_GAIN_TIME] # [Bool]���ƥ��ȥ��ʥꥪ�ǻ��֤�ʤ��⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: �ץ��쥹�С���ɽ���⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_no_progress_bar_mode?()
      return @@hConf[CFG_NO_PROGRESS_BAR] # [Bool]�ץ��쥹�С���ɽ���⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: TTJ���ϥ⡼�ɤ�ͭ�������֤�
    #=================================================================
    def is_enable_ttj_mode?()
      return @@hConf[CFG_ENABLE_TTJ] # [Bool]TTJ���ϥ⡼�ɤ�ͭ����
    end

    #=================================================================
    # ������: �ץ�ե����뤬ASP�������å�
    #=================================================================
    def is_asp?()
      return (@@hConf[CFG_PROFILE] == CFG_PROFILE_ASP) # [Bool]�ץ�ե����뤬ASP��
    end

    #=================================================================
    # ������: �ץ�ե����뤬FMP�������å�
    #=================================================================
    def is_fmp?()
      return (@@hConf[CFG_PROFILE] == CFG_PROFILE_FMP) # [Bool]�ץ�ե����뤬FMP��
    end

    #=================================================================
    # ������: �����ޥ������ƥ����㤬�����뤫�����å�
    #=================================================================
    def is_timer_local?()
      return (@@hConf[CFG_TIMER_ARCH] == TSR_PRM_TIMER_LOCAL) # [Bool]�����ޥ������ƥ����㤬�����뤫
    end

    #=================================================================
    # ������: �ץ�ե����뤬���åȤ���Ƥ��뤫�����å�
    #=================================================================
    def is_profile_set?()
      return (!@@hConf[CFG_PROFILE].nil?()) # [Bool]�ץ�ե����뤬���åȤ���Ƥ��뤫
    end

    #=================================================================
    # ������: IRC�������ƥ����㤬�����Х뤫�����å�(�����Ի���)
    #=================================================================
    def is_irc_global?()
      return (@@hConf[CFG_IRC_ARCH] == TSR_PRM_IRC_GLOBAL) #[Bool]IRC�������ƥ����㤬�����Х뤫
    end

    #=================================================================
    # ������: IRC�������ƥ����㤬�����뤫�����å�(�����Ի���)
    #=================================================================
    def is_irc_local?()
      return (@@hConf[CFG_IRC_ARCH] == TSR_PRM_IRC_LOCAL) #[Bool]IRC�������ƥ����㤬�����뤫
    end

    #=================================================================
    # ������: IRC�������ƥ������ξ�����ݡ��Ȥ��뤫�����å�(�����Ի���)
    #=================================================================
    def is_irc_combination?()
      return (@@hConf[CFG_IRC_ARCH] == TSR_PRM_IRC_COMBINATION) #[Bool]IRC�������ƥ������ξ�����ݡ��Ȥ��뤫
    end

    #=================================================================
    # ������: YAML�饤�֥���Ȥ������֤�
    #=================================================================
    def use_yaml_library?()
      return (@@hConf[CFG_YAML_LIBRARY] == CFG_LIB_YAML) #[Bool]YAML�饤�֥���Ȥ���
    end

    #=================================================================
    # ������: GCOV��������뤫���֤�
    #=================================================================
    def enable_gcov?()
      return (@@hConf[CFG_ENABLE_GCOV] == true) #[Bool]GCOV��������뤫
    end

    #=================================================================
    # ������: ����������뤫���֤�(�����Ի���)
    #=================================================================
    def enable_log?()
      return (@@hConf[CFG_ENABLE_LOG] == true) #[Bool]����������뤫
    end

    #=================================================================
    # ������: �ͤ�����ʾ���Ū���ѻߡ�
    #=================================================================
    def get(sKey)
      check_class(String, sKey)  # ����

      return @@hConf[sKey] # [String, Bool]������
    end

    #=================================================================
    # ������: �ݻ����Ƥ�������ꥻ�åȤ���
    #       : �ʥ��Х�å��ƥ��ȥץ�����ѡ�
    #=================================================================
    def reset()
      @@hConf = {}
    end
  end
end
